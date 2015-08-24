%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   MAC 0315 - Programacao Linear                                           %
%   Professor Ernesto Birgin                                                %
%                                                                           %
%   Exercicio Programa 3 - Simplex de Duas Fases                            %
%                                                                           %
%   Christian Massao Takagi                                  nUSP 1234567   %
%   Fernando Tomio Yamamotu Tanaka                           nUSP 6920230   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ ind ret invB Basicas ] = fase2 ( A, b, c, m, n, x, Basicas, invB )
   % Argumentos
   %  A       - matriz de restricoes
   %  b       -
   %  c       - vetor de pesos
   %  m       - numero de restricoes
   %  n       - numero de variaveis
   %  x       - solucao viavel basica inicial
   %  Basicas - variveis basicas
   %  invB    - inversa da matriz basica

   % Retorna
   %  ind - indica as condicoes que o algoritmo parou
   %        0  - se o problema encontrou uma solucao otima
   %        -1 - se o problema nao possui solucao otima
   %  ret - retorno
   %        se o problema possuui solucao otima, ret = x, onde x e a solucao
   %        otima para o problema
   %        se o problema nao possui solucao otima ret = d, onde d e a direcao
   %        para o onde o problema nao possui solucao otima
   %  invB - inversa da matriz basica
   %  Basicas - variaveis basicas

   iteracao = 0;

   while ( 1 )

      printf ( "\n=== Iteracao %d ===\n\n", iteracao )
      iteracao = iteracao + 1;

      xB = invB * b;

      % impressao 1
      disp ( 'Variaveis Basicas' )
      for i = 1 : m
         printf ( "  %d %f\n", Basicas(i), xB(i) )
      endfor

      % impressao 2
      printf ( "Valor da funcao objetivo: %f\n", c * x )

      [ fim cbarra entra ] = CustosReduzidos ( A, invB, c, m, n, Basicas );

      % impressao 3
      disp ( 'Custos Reduzidos' )
      for i = 1 : n
         if ( ! ismember ( i, Basicas ) )
            printf ( "  %d %f\n", i, cbarra(i) )
         endif
      endfor

      if ( fim == 1 )
         disp ( 'X e uma solucao otima' )
         ind = 0;
         ret = x;
         break;
      endif

      % impressao 4
      printf ( "Entra na base: %d\n", entra )

      [ dB d ] = Direcao ( A, invB, n, Basicas, entra );

      % impressao 5
      disp ( 'Direcao' )
      for i = 1 : m
         printf ( "  %d %f\n", Basicas(i), d(Basicas(i)) )
      endfor

      [ fim theta sai k ] = ThetaEstrela ( m, xB, dB, Basicas );

      % impressao 6
      printf ( "Theta* = %f\n", theta )

      if ( fim == 1 )
         disp ( 'O problema nao tem solucao otima' )
         disp ( 'O vetor direcao e' )
         disp ( d )
         ind = -1;
         ret = d;
         break
      endif

      % impressao 7
      printf ( "Sai da base: %d\n", sai )

      % atualizamos x
      x = x + theta * d';

      % atualizamos as variaveis basicas
      Basicas( find ( Basicas == sai ) ) = entra;

      % atualizamos a inversa da base
      invB = AtualizaInvB ( invB, m, -dB, k );

   endwhile
endfunction

function [ fim cbarra entra ] = CustosReduzidos ( A, invB, c, m, n, Basicas )
   % Atgumentos
   %  A       - matriz de restricoes
   %  invB    - inversa da matriz basica
   %  c       - verto de custos
   %  m       - numero de restricoes
   %  n       - numero de variveis
   %  Basicas - vetor com as variveis basicas

   % Retorna
   %  fim     - indica se a solucao e otima
   %  cbarra  - vetor de custos reduzidos
   %  entra   - variavel que ira entrar na base

   fim = 0;
   entra = -1;

   cTB = c(Basicas);

   pT = cTB * invB;

   for i = 1 : n
      if ( ! ismember ( i, Basicas ) )
         cbarra(i) = c(i) - pT * A( :, i );
      else
         cbarra(i) = 0;
      endif
   endfor

   % procuramos o custo reduzido negativo de menor indice
   minimo = inf;
   for i = 1 : n
      if ( cbarra(i) < 0 && cbarra(i) < minimo )
         minimo = cbarra(i);
         entra  = i;
         break
      endif
   endfor

   % se todos os custos reduzidos forem positivos, entao estamos em uma solucao
   % otima, o algoritmo terminou
   if ( minimo == inf )
      fim = 1;
   endif
endfunction

function [ dB d ] = Direcao ( A, invB, n, Basicas, entra )
   % Argumentos
   %  A       - matriz de restricoes
   %  invb    - inversa da matriz basica
   %  n       - numero de variaveis
   %  Basicas - variaveis basicas
   %  entra   - variavel que ira entrar na base

   % Retorna
   %  dB      - vetor dB
   %  d       - vetor direcao

   dB = - invB * A( :, entra );
   d  = zeros ( 1, n );

   for i = 1 : n
      if ( ismember ( i, Basicas ) )
         d(i) = dB(Basicas == i);
      else if( i == entra )
         d(i) = 1;
      endif
      endif
   endfor
endfunction

function [ fim theta sai k ] = ThetaEstrela ( m, xB, dB, Basicas )
   fim = 0;
   theta = inf;
   sai = -1;
   k   = -1;

   u = -dB;

   for i = 1 : m
      if ( u(i) > 0 && theta > ( xB(i) / u(i) ) )
         theta = xB(i) / u(i);
         sai = Basicas(i);
         k = i;
      endif
   endfor

   if ( theta == inf )
      fim = 1;
   endif
endfunction

function [ invB ] = AtualizaInvB ( invB, m, u, k )
   ek = eye ( m )( :, k );
   diff = ( u != ek );

   if ( ismember ( 1, diff ) )
      temp = [ invB u ];
      fator = temp( k, m + 1 );
      temp( k, : ) = temp ( k, : ) / fator;

      for i = 1 : m
         if ( i != k )
            fator = temp ( i, m + 1 );
            temp( i, : ) = temp( i, : ) - fator * temp( k, : );
         endif
      endfor

      invB = temp ( :, 1 : m );
   endif
endfunction

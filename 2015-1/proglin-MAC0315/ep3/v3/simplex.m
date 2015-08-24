%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   MAC 0315 - Programacao Linear                                            %
%   Professor Ernesto Birgin                                                 %
%                                                                            %
%   Exercicio Programa 3 - Simplex de Duas Fases                             %
%                                                                            %
%   Christian Massao Takagi                                   nUSP 1234567   %
%   Fernando Tomio Yamamotu Tanaka                            nUSP 6920230   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ fim cbarra entra ] = CustosReduzidos ( A, invB, c, m, n, Basicas )
   % Argumentos
   %   A       - matriz de retricoes
   %   invB    - inversa da matrix B ( B - base )
   %   c       - vetor de custos
   %   m       - numero de restricoes
   %   n       - numero de variaveis
   %   Basicas - vetor que indica as variaveis basicas
   %
   % Retorno
   %   fim     - indica se a solucao e otima
   %   cbarra  - vetor de custos reduzidos
   %   entra   - indice da varivel ira entrar na base

   fim = 0;
   entra = -1;

   cTB = c(Basicas);

   pT = cTB * invB;

   for i = 1 : n
      if ( ! ismember ( i, Basicas ) )
         cbarra(i) = c(i) - pT * A(:,i);
      else
         cbarra(i) = 0;
      endif
   endfor

   % procuramos o menor custo reduzido negativo.
   % em caso de empate, pegamos a variavel de menor indice.
   minimo = inf;
   for i = 1 : n
      if ( cbarra(i) < 0 && cbarra(i) < minimo )
         minimo = cbarra(i);
         entra  = i;
         break
      endif
   endfor

   % se o custo reduzido minimo e + infinito, entao todos os custos reduzidos
   % sao positivos. o algoritmo para.
   if ( minimo == inf )
      fim =  1;
   endif
endfunction

function [ dB d ] = Direcao ( A, invB, n, Basicas, entra )
   % Argumentos
   %   A - matriz de restricoes
   %   invB - inversa da matriz basica
   %   entra - variavel que ira entrar na base
   %
   % Retorno
   %   dB - vetor dB
   %   d - vetor direcao

   dB = - invB * A( :, entra );
   d  = zeros ( 1, n );

   for i = 1 : n
      if ( ismember ( i, Basicas ) )
         d(i) = dB( i == Basicas );
      else if i == entra
         d(i) = 1;
      endif
      endif
   endfor
endfunction

function [ fim theta sai k ] = ThetaEstrela ( m, xB, dB, Basicas )
   % Argumentos
   %   m       - numero de restricoes, numero de variaveis basicas
   %   xB      - valores de x associado as variaveis basicas
   %   dB      - vetor dB
   %   Basicas - vetor que contem as variaveis basicas
   %
   % Retorno
   %   fim     - indica se o problema tem custo otimo -infinito
   %   u       - vetor u
   %   sai     - indice da variavel que ira sair da base
   %   k       - posicao da variavel basica que ira sair da base

   fim   = 0;
   theta = inf;
   sai   = -1;
   k     = -1;

   u = -dB;

   % procuramos o indice das variaveis basicas que minimiza o valor de theta
   % estrela.
   for i = 1 : m
      if ( u(i) > 0 && theta > ( xB(i) / u(i) ) )
         theta = xB(i) / u(i);
         sai   = Basicas(i);
         k     = i;
      endif
   endfor

   % se theta == infinito, quer dizer que nao existe componente de u, com
   % valores positivos, se u <= 0 entao theta = + infinito.
   if ( theta == inf )
      fim = 1;
   endif
endfunction

function [ invB ] = AtualizaInvB ( invB, m, u, k )
   % Argumentos
   %   invB - inversa da matriz basica
   %   u    - vetor u
   %   k    - indice da variavel que sai da base
   %
   % Retorno
   %   invB - inversa da matriz basica da proxima interacao

   ek = eye(m)(:,k);   % k-esima coluna da matriz identidade
   diff = ( u != ek ); % diferenca entre u e ek, componente a componente

   if ( ismember ( 1, diff ) )
      temp = [ invB u ];
      fator = temp( k, m + 1 );
      temp( k, : ) = temp( k, : ) / fator;

      for i = 1 : m
         if ( i != k )
            fator = temp( i, m + 1 );
            temp( i, : ) = temp( i, : ) - fator * temp( k, : );
         endif
      endfor

      invB = temp( :, 1:m );
   endif
endfunction

function [ ind ret invB Basicas ] = fase2 ( A, b, c, m, n, x, Basicas, invB )
   % Argumentos
   %   A    - matriz de restricoes
   %   b    - 
   %   c    - vetor de custos
   %   m    - numero de restricoes
   %   n    - numero de variaveis
   %   x    - inicial solucao viavel basica
   %
   % Retorno
   %   ind  - indicador para o fim do algoritmo
   %   v    - 
   %   invB - inversa da matriz basica

   iteracao = 0;

   while ( 1 )

      printf ( "\n Iteracao #%d\n\n", iteracao )
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
         break
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

      % atualizamos a inversa de B
      invB = AtualizaInvB ( invB, m, -dB, k );

   endwhile

endfunction

function [ fim x auxA auxb m invB Basicas ] = fase1 ( A, b, c, m, n )

   fim = 0;
   x   = [];

   % Criamos o problema auxiliar
   auxA = [ A eye(m) ];
   auxb = b;
   auxc = [ zeros(1, n) ones(1, m) ];
   auxx = [ zeros(n, 1); b ];
   auxn = n + m;
   Artificiais = [ 1 : m ] + n;

   Basicas = Artificiais;
   invB = eye(m);

   for i = 1 : m
      if ( b(i) < 0 )
         auxA( i, : ) = auxA( i, : ) * -1;
         auxb(i) = auxb(i) * -1;
      endif
   endfor

   [ ind auxx invB Basicas ] = fase2 ( auxA, auxb, auxc, m, auxn, auxx, Basicas, invB );

   if ( auxc * auxx > 0 )
      % problema inviavel 
      fim = 1;
      break
   endif

   indArt = ismember ( Artificiais, Basicas );

   matriz = invB * A;

   if ( ismember ( 1, indArt ) )
   % existem variaveis artificiais nas variaveis basicas
      for i = 1 : m
         if ( indArt(i) == 1 )
            linha = matriz( i, 1 : n );
            if ( sum ( linha != 0 ) == 1 ) % LI
               entra = find ( linha );
               Basicas( i ) = entra;
               u = matriz ( :, entra );

               invB = AtualizaInvB ( invB, m, u, i );

               fator = matriz( i, entra );
               matriz( i, : ) = matriz( i, : ) / fator;
               for j = 1 : m
                  if ( j != i )
                     fator = matriz( j, entra ) / matriz( i, entra );
                     matriz( j, : ) = matriz( j, : ) - fator * matriz( i, : );
                  endif
               endfor
            else %LD
               auxA( i, : ) = [];
               auxA( :, Basicas(i) ) = [];
               auxb( i ) = [];
               Basicas( i ) = [];
               m = m - 1;
            endif
         endif
      endfor
   endif

   % nao existem variaveis artificiais nas variaveis basicas

   invB = inv ( auxA( :, Basicas ) );

   x = auxx( 1 : n );

endfunction

function [ ind v x ] = simplex ( A, b, c, m, n )

   [ fim x newA newb newm invB Basicas ] = fase1 ( A, b, c, m, n );

   if ( fim == 1 )
      disp ( 'Problema inviavel' )
      ind = 1;
      v = [];
      x = [];
      break
   endif

   [ fim ret invB Basicas ] = fase2 ( newA, newb, c, newm, n, x, Basicas, invB
);

   if fim == 0
      ind = 0;
      v   = [];
      x   = ret;
   endif

   if fim == -1
      ind = -1;
      v   = ret;
      x   = [];
   endif
    
endfunction

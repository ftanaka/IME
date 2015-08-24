%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   MAC 0315 - Programacao Linear                                           %
%   Professor Ernesto Birgin                                                %
%                                                                           %
%   Exercicio Programa 3 - Simplex de Duas Fases                            %
%                                                                           %
%   Christian Massao Takagi                                  nUSP 1234567   %
%   Fernando Tomio Yamamotu Tanaka                           nUSP 6020230   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source fase2.m

function [ fim x auxA auxb m invB Basicas ] = fase1 ( A, b, c, m, n )
   % Argumento
   %  A       - matriz de restricoes
   %  b       - 
   %  c       - funcao objetivo
   %  m       - numero de restricoes
   %  n       - numero de variaveis

   % Retorna
   %  fim     - indica se o programa deve terminar
   %        1 - sim
   %        0 - nao
   %  x       - uma solucao viavel basica inicial
   %  auxA    - matriz auxiliar de restricoes
   %  auxb    - matriz auxiliar de valores
   %  m       - numero de restricoes
   %  invB    - inversa da matriz basica
   %  Basicas - vetor com as variaveis basicas

   fim = 0;
   x   = [];

   % Criamos o problema auxiliar, com as variaveis artificiais
   auxA        = [ A eye(m) ]; 
   auxb        = b;                         
   auxc        = [ zeros(1, n) ones(1, m) ];
   auxx        = [ zeros(n, 1); b];
   auxn        = n + m;
   Artificiais = [ 1 : m ] + n;    % vetor com as variaveis artificiais

   Basicas = Artificiais;
   invB    = eye(m);

   for i = 1 : m
      if ( b(i) < 0 )
         auxA( i, : ) = auxA( i, : ) * -1;
         auxb(i)      = aux(b) * -1;
      endif
   endfor

   [ind auxx invB Basicas]=fase2(auxA, auxb, auxc, m, auxn, auxx, Basicas,invB);

   % verificamos se o problema e inviavel
   if ( auxc * auxx > 0 )
      % o problema inviavel, podemos parar o algoritmo
      fim = 1;
      break
   endif

   % verificamos a existencia de variaveis artificiais nas variaveis basicas
   existeArt = ismember ( Artificiais, Basicas );

   if ( ismember ( 1, existeArt ) )
      [auxA auxb invB m Basicas] = RetiraArtificiais (auxA, auxb, m, n, invB,
Artificiais, Basicas);
   endif

   % nao existem mais variaveis artificiais nas variaveis basicas
   invB = inv ( auxA( :, Basicas ) );

   x = auxx( 1 : n );
endfunction

function [ newA newb invB m Basicas] = RetiraArtificiais ( A, b, m, n, invB,
Artificiais, Basicas )
   % Argumentos
   %  A      - matriz de restricoes
   %  b      - 
   %  m      - numero de restricoes
   %  n      - numero de variaveis
   %  invB   - inversa da matriz basica
   %  Basica - variaveis basicas

   % Retorna
   % newA - nova matriz de restricoes
   % newB - novo vetor b
   % invB - inversa da matriz basica
   % m    - numero de restricoes

   matriz = invB * A;

   BasicasArtificiais = ismember ( Artificiais, Basicas );

   for sai = 1 : m
      if ( BasicasArtificiais(sai) == 1 )
         linha = matriz( sai, 1 : n );

         if ( sum ( linha != 0 ) == 1 ) % LI
            % caso LI, nesse caso podemos substituir a variavel artificial pela
            % variavel nao basica "entra", pois ela e linearmente independente
            % em A(B(i)). Para substitui-la fazemos uma pivoteacao degenerada.
            entra = find ( linha );
            Basicas(sai) = entra;

            u = matriz( :, entra );
            invB = AtualizaInvB ( invB, m, u, sai );

            matriz = invB * A;
         else % LD
            % caso LD, nesse caso esta restricao e redundante e portanto podemos
            % elimina-la
            A( sai, : ) = []; 
            A( :, entra ) = [];
            b( sai ) = [];
            Basicas(sai) = [];
            m = m - 1;
         endif
      endif
   endfor

   newA = A;
   newb = b;
endfunction

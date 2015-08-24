function [ ind v x ] = simplex ( A, b, c, m, n )

   disp ( 'FASE 1' )

   for i = 1 : m
      if ( b(i) < 0 )
         A(i, :) = - A(i,:)
      endif
   endfor

   # Criamos um problema auxiliar
   # minimizar e * y
   # s. a.     Ax + Iy = b
   #           x, y, >= 0

   # adicionamos as variaveis artificiais
   auxA = [ A eye(m) ];
   auxN = n + m;
   auxC = [ zeros( 1, n ) ones( 1, m ) ];
   Artificiais = [ 1: m ]' + n; 

   # uma possivel solucao para o problema auxiliar
   x = [ zeros( n, 1 ); b ];

   Basicas = find ( x );
   iteracao = 0;

   B = auxA( :, Basicas );
   invB = inv ( B );

   cB = auxC ( Basicas );
   xB = invB * b;
   cbarra = auxC - cB * invB * auxA;

   tableau = [ -cB * xB  cbarra
               xB        invB * auxA ];

   while ( 1 )

      printf ( "\nIteracao %d\n\n", iteracao ) 
      disp ( x )
      disp ( tableau )

      # impressao 1
      disp ( 'Variaveis Basicas' )
      for i = 1 : m
         printf ( "  %d %f\n", Basicas(i), tableau( i + 1, 1 ) )
      endfor

      # impressao 2
      printf ( "Valor funcao objetivo: %f\n", tableau( 1, 1 ) )

      # impressao 3
      disp ( 'Custos reduzidos' )
      for i = 1 : auxN
         if ( ! ismember ( i, Basicas ) )
            printf ( "  %d %f\n", i, tableau( 1, i + 1 ) )
         endif
      endfor

      # procura o menor custo negativo 
      minimo = inf;
      for i = 1 : auxN
         if ( tableau( 1, i + 1 ) < minimo )
            minimo = tableau( 1, i + 1 );
            entra  = i;
            coluna = i + 1;
         endif
      endfor

      # verifca se existe custo reduzidos negativos
      if ( minimo >= 0 )
         break
      endif

      # impressao 4
      printf ( "Entra na base: %d\n", entra )

      # calculo do vetor direcao
      u = tableau ( 2 : m + 1, coluna );
      dB = - u;
      d = zeros ( 1, auxN );
      for i = 1 : auxN
         if ( ismember ( i, Basicas ) )
            d(i) = dB( i == Basicas );
         else if ( i == entra )
            d(i) = 1;
         endif
         endif
      endfor

      # imporessao 5
      disp ( 'Direcao' )
      for i = 1 : m
         printf ( "  %d %f\n", Basicas(i), d( Basicas( i ) ) )
      endfor

      # calculo de theta estrela
      theta = inf;
      for i = 1 : m
         if ( u(i) > 0 && theta > tableau( i + 1, 1 ) / u(i) )
            theta = tableau( i + 1, 1 ) / u(i);
            sai    = Basicas(i);
            linha  = i + 1;
         endif
      endfor

      # impressao 6
      printf ( "Theta* : %f\n", theta )

      # verifica se existe u(i) > 0
      if ( theta <= 0 )
         break
      endif 

      # impressao 7
      printf ( "Sai da base: %d\n", sai )

      # atualizamos o valor de x
      x = x + theta * d';

      k = tableau( linha, coluna );
      tableau( linha, : ) = tableau( linha, : ) / k;

      for i = 1 : m + 1
         if ( i != linha )
            r = tableau( i, coluna ) / tableau( linha, coluna );
            tableau( i, : ) = tableau( i, : ) - r * tableau( linha, : );
         endif
      endfor

      Basicas( find ( Basicas == sai ) ) = entra;

      iteracao = iteracao + 1;

   endwhile

   if ( tableau( 1, 1 ) != 0 )
      disp ( 'Problema inviavel' )
      ind = v = x = -1;
      break
   endif

   # contem variaveis artificiais na base
   indArt = ismember ( Artificiais, Basicas );
   while ( ismember ( 1, indArt ) )

      for i = 1 : m
         if ( indArt(i) == 1 )
            sai = Basicas( i );
            linha = i + 1;
            mcolunas = tableau( i + 1, 2 : m + 1 );
            soma = sum ( mcolunas != 0 );

            if ( soma == 0 )
               Basicas( i, : ) = []; # removo a variavel B(i) das Basicas
               tableau( linha, : ) = []; # removo a linha i do tableau
               tableau( :, sai + 1 ) = []; # removo a coluna i do tableau
               tableau( 1, : ) = []; # remova a linha zero
               x( sai ) = 0;

               m = m - 1;
               auxN = auxN - 1;
            else if ( soma == 1 ) # LI
               entra = find ( mcolunas );
               coluna = entra + 1;
               k = mcolunas( entra );
               tableau( linha, : ) = tableau ( linha, : ) / k;
               for j = 1 : m + 1
                  if ( j != linha )
                     r = tableau( j, coluna ) / tableau( linha, coluna );
                     tableau( j, : ) = tableau( j, : ) - r * tableau( linha,:);
                  endif
               endfor
               Basicas( find ( Basicas == sai ) ) = entra;
            endif
            endif

         endif
         indArt = ismember ( Artificiais, Basicas );
      endfor

   endwhile
   
   # invariante base sem variaveis artificiais
   # removendo as colunas das variaveis artificiais
   tableau = resize ( tableau, m, n + 1 );

   Basicas

   cTB = c(Basicas)
   B = tableau( :, Basicas + 1)
   b = tableau( :, 1 )
   cbarra = c - cTB * inv ( B ) * tableau(2:m, : )
   

endfunction

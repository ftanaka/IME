# A - matriz
# b - 
# c - funcao objetivo
# m - numero de restricoes
# n - numero de variaveis

function tableau ( A, b, c, m , n, x )

   Basicas = find ( x );
   NaoBasicas = find ( x == 0 );
   iteracao = 0;

   B = A( :, Basicas );
   invB = inv ( B );

   cB = c( Basicas );
   xB = (invB * b);
   cbarra = c - cB * invB * A;

   tableau = [ - cB * xB   cbarra 
               xB          invB * A ];

   while ( 1 )

      printf ( "\n\nIteracao #%d\n\n", iteracao )

      # impressao 1
      disp ( 'Variaveis Basicas' )
      for i = 1 : m
         printf ( "  %d - %f\n", Basicas(i), x(Basicas(i)) )
      endfor

      # impressao 2
      printf ( "Valor da funcao objetivo = %f\n", tableau(1,1) )

      # impressao 3
      disp ( 'Custos reduzidos' )
      for i = 1: n
         if ( ismember ( i, NaoBasicas ) )
            indice = NaoBasicas ( NaoBasicas == i );
            printf ( "  %d - %f\n", indice, tableau(1, i + 1 ) )
         endif
      endfor

      flag = 0;
      for i = 2 : n
         if ( tableau ( 1, i ) < 0 )
            flag = 1;
            break
         endif
      endfor

      if flag == 0
         disp ( 'O problema possui solucao otima' )
         disp ( 'x e solucao otima' )
         disp ( tableau ( :, 1 ) )
         break
      endif

      minimo = -inf;
      for i = 2 : n
         if ( tableau( 1, i ) < 0 && minimo < tableau( 1, i ) )
            minimo = tableau ( 1, i );
            coluna = i;
            entra  = i - 1;
         endif
      endfor

      # impressao 4
      printf ( "Entra na base: %d\n", entra )

      u = tableau ( 2 : m + 1, coluna );
      dB = -u;
      d = zeros( 1, n );
      for i = 1:n
         if ( ismember ( i, Basicas ) )
            d(i) = dB( i == Basicas );
         else if i == entra
            d(i) = 1;
         endif
         endif
      endfor

      # impressao 5
      disp ( 'direcao' )
      for i = 1:m
         printf ( "  %d - %f\n", Basicas(i), d(Basicas(i)) )
      endfor

      theta = inf;
      for i = 1 : m
         if ( u(i) > 0 && theta > xB(i) / u(i) )
            theta = xB(i) / u(i);
            linha = i + 1;
            sai   = Basicas(i);
         endif
      endfor

      # impressao 6
      printf ( "Theta* = %f\n", theta )

      if ( theta == inf )
         disp ( 'O problema nao possui solucao otima' )
         break
      endif

      # impressao 7
      printf ( "Sai da base: %d\n", sai )

      k = tableau ( linha, coluna );
      tableau( linha, : ) = tableau( linha, : ) / k;

      for i = 1 : m + 1
         if ( i != linha )
            r = tableau( i, coluna ) / tableau( linha, coluna );
            tableau( i, : ) = tableau( i, : ) - r * tableau ( linha, : );
         endif
      endfor

      Basicas( find ( Basicas == sai ) ) = entra;
      NaoBasicas ( find ( NaoBasicas == entra ) ) = sai;

      iteracao = iteracao + 1;

   endwhile

endfunction

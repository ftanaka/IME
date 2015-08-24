function [ ind tableau Basicas iteracao ] = Tableau ( tableau, Basicas, m, n, x,
iteracao )

   while ( 1 )

      printf ( "\nIteracao #%d\n\n", iteracao )

      iteracao = iteracao + 1;

      # impressao 1
      disp ( 'Variaveis Basicas' )
      for i = 1 : m
         printf ( "  %d %f\n", Basicas(i), x(Basicas(i)) )
      endfor

      # impressao 2
      printf ( "Valor da funcao objetivo = %f\n", tableau( 1, 1 ) )

      # impressao 3
      disp ( 'Custos reduzidos' )
      for i = 1 : n
         if ( ! ismember ( i, Basicas ) )
            printf ( "  %d %f\n", i, tableau( 1, i + 1 ) )
         endif
      endfor

      # procura o menor custo reduzido
      minimo = inf;
      for i = 1 : n
         if ( tableau( 1, i + 1 ) < 0 && tableau( 1, i + 1) < minimo )
            minimo = tableau( 1, i + 1 )
            entra  = i;
            coluna = i + 1;
         endif
      endfor

      # verifica se existe custos reduzidos negativos
      if ( minimo >= 0 )
         ind = 0;
         break
      endif

      # impressao 4
      printf ( "Entra na base: %d\n", entra )

      # calculo do vetor direcao
      u = tableau ( 2 : m + 1, coluna );
      dB = -u;

      d = zeros ( 1, n );
      for i = 1 : n
         if ( ismember ( i, Basicas ) )
            d(i) = dB( i == Basicas );
         else if ( i == entra )
            d(i) = 1;
              endif
         endif
      endfor

      # impressao 5
      disp ( 'Direcao' )
      for i = 1 : m
         printf ( "  %d %f\n", Basicas(i), d( Basicas(i) ) )
      endfor

      # calculo de theta estrela
      theta = inf;
      for i = 1 : m
         if ( u(i) > 0 && theta > tableau( i + 1, 1 ) / u(i) )
            theta = tableau( i + 1, 1 ) / u(i);
            sai   = Basicas(i);
            linha = i + 1;
         endif
      endfor

      # impressao 6
      printf ( "Theta*: %f\n", theta )

      # verifica se existe u(i) > 0
      if ( theta == inf )
         ind = 1;
         break
      endif

      # impressao 7
      printf ( "sai da base: %d\n", sai )

      # atualiza o valor de x
      x = x + theta * d';

      k = tableau( linha, coluna );
      tableau( linha, : ) = tableau( linha, : ) / k;

      for i = 1 : m + 1
         if ( i != linha )
            r = tableau ( i, coluna ) / tableau ( linha, coluna );
            tableau ( i, : ) = tableau ( i, : ) - r * tableau( linha, : );
         endif
      endfor

      Basicas( find ( Basicas == sai ) ) = entra;

   endwhile

endfunction

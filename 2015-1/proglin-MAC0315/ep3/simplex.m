#!/usr/bin/octave

##############################################################################
#   MAC 0315 - Programacao Linear                                            #
#   Exercicio Programa 02 - Metodo Simplex - Fase 2                          #
#                                                                            #
#   Chrstian                                                  nUSP 1234567   #
#   Fernando Tomio Yamamotu Tanaka                            nUSP 6920230   #
##############################################################################

### Bibliografia
# Introduction to Linear Programming, Applications and extensions - Darst
# Notas de aulas do professor Ernesto
# Notas de aulas do professor Queiroz
###

# A - matriz
# b -
# c - funcao objetivo
# m - numero de restricoes
# n - numero de variaveis
# x - uma solucao viavel basica

function [ ind v ] = simplex ( A, b, c, m, n, x )
% SIMPLEX ( A, b, c, m, n, x ) Calculates x so Ax = b, that minimize c

   varBasicas = find ( x );
   varNaoBasicas = find ( x == 0 );
   iteracao = 0;

   B = A( :, varBasicas );
   Binv = inv ( B );

   while ( 1 )
      printf ( "\n\n### Iteracao %d\n\n", iteracao )

      # impressao 1
      disp ( 'Variaveis Basicas' )
      for i = 1:m
         printf ( "%d  %f\n", varBasicas(i), x(varBasicas(i)) )
      endfor

      # impressao 2
      printf ( "Valor da funcao objetivo = %f\n", c * x )

      ### calculo xB
      xB = Binv * b;

      ### calculo dos custos reduzidos
      pT = c(:,varBasicas) * Binv;
      cbarra = zeros ( 1, n );
      cbarra(:,varNaoBasicas) = c(:,varNaoBasicas) - pT * A(:,varNaoBasicas);

      # impressao 3
      disp ( 'Custos reduzidos' )
      for i = 1:n
         if ( ismember ( i, varNaoBasicas ) )
            indice = varNaoBasicas( i == varNaoBasicas );
            printf ( "%d  %f\n", indice, cbarra(indice) )
         endif
      endfor

      ### procura pelo menor custo reduzido
      minimo = Inf;
      entra  = -1;
      for i = 1:n
         if ( cbarra ( i ) < minimo )
            minimo = cbarra ( i );
            entra  = i;
         endif
      endfor

      ### verificacao dos custos reduzidos
      if ( minimo >= 0 )
         disp ( 'X e uma solucao otima' )
         ind = 0;
         v   = x;
         break
      endif

      # impressao 4
      printf ( "Entra na base: %d\n", entra )

      ### calculo do vetor direcao
      dB = - Binv * A(:,entra);
      d  = zeros ( 1, n );
      for i = 1:n
         if ( ismember ( i, varBasicas ) )
            d(i) = dB( i == varBasicas );
         else if i == entra
            d(i) = 1;
         endif
         endif
      endfor 

      # impressao 5
      disp ( 'Direcao' )
      for i = 1:m
         printf ( "%d  %f\n", varBasicas(i), d(varBasicas(i)) )
      endfor

      ### calculo de u
      u = -dB;

      ### verificacao de u
      flag = 0;
      for i = 1:m
         if ( u(i) > 0 )
            flag = 1;
            break
         endif
      endfor
      if ( flag == 0 )
         disp ( 'O problema nao tem solucao otima' )
         disp ( 'O vetor direcao e' )
         disp ( d )
         ind  = -1;
         v    = d;
      endif

      ### calculo de theta*
      theta = Inf;
      sai   = -1;
      k     = -1;
      for i = 1:m
         if ( u(i) > 0 )
            calculo = xB(i) / u(i);
            if ( theta > calculo )
               theta = calculo;
               sai   = varBasicas(i);
               k     = i;
            endif
         endif
      endfor

      # impressao 6
      printf ( "Theta* = %f\n", theta )

      # impressao 7
      printf ( "Sai da base: %d\n", sai )

      ### atualizamos o valor de x
      x = x + theta * d';

      ### atualizacao das variaveis basicas e nao basicas
      varBasicas( k ) = entra;
      varNaoBasicas( entra == varNaoBasicas ) = sai;

      ### se necessario calculamos a inversa da nova base
      ek = eye(m)(:,k);
      diff = ( u != ek );
      if ( ismember ( 1, diff ) )
         temp = [ Binv u ];
         fator = temp(k,m+1);
         temp(k,:) = temp(k,:) / fator;

         for i = 1:m
            if ( i != k )
               fator = temp(i,m+1);
               temp(i,:) = temp(i,:) - fator * temp(k,:);
            endif
         endfor

         for i = 1:m
            Binv(:,i) = temp(:,i);
         endfor
      endif

      iteracao = iteracao + 1;

   end

   ### clear das variaveis utilizadas
   clear -v ( B )
   clear -v ( Binv )
   clear -v ( calculo )
   clear -v ( cbarra )
   clear -v ( d )
   clear -v ( dB )
   clear -v ( diff )
   clear -v ( ek )
   clear -v ( entra )
   clear -v ( fator )
   clear -v ( flag )
   clear -v ( i )
   clear -v ( indice )
   clear -v ( iteracao )
   clear -v ( k )
   clear -v ( minimo )
   clear -v ( pT )
   clear -v ( sai )
   clear -v ( temp )
   clear -v ( theta )
   clear -v ( u )
   clear -v ( varBasicas )
   clear -v ( varNaoBasicas )
   clear -v ( xB )

endfunction

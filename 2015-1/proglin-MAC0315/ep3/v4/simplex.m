%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   MAC 0315 - Programacao Linear                                            %
%   Professor Ernesto Birgin                                                 %
%                                                                            %
%   Exercicio Programa 3 - Simplex de Duas Fases                             %
%                                                                            %
%   Christian Massao Takagi                                   nUSP 1234567   %
%   Fernando Tomio Yamamotu Tanaka                            nUSP 6920230   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source fase1.m

function [ ind v x ] = simplex ( A, b, c, m, n )
   % Argumentos
   %  A - matriz de retricoes
   %  b - 
   %  c - funcao objetivo
   %  m - numero de restricoes
   %  n - numero de variaveis

   % Retorno
   %  ind - indicador da existencia de solucoes para o problema
   %        -1 - se o problema for ilimitado
   %         0 - se o problema tiver uma solucao otima
   %         1 - se o problema for inviavel

   printf ( "===== FASE 1 =====\n" )

   [ fim x newA newb newm invB Basicas ] = fase1 ( A, b, c, m, n );

   if ( fim == 1 )
      disp ( 'Problema inviavel' )
      ind = 1;
      v = [];
      x = [];
      return;
   endif

   printf ( "===== FASE 2 =====\n" )

   [fim ret invB Basicas] = fase2 (newA, newb, c, newm, n, x, Basicas, invB);

   if ( fim == 0 )
      ind = 0;
      v = [];
      x = ret;
   endif
   
   if ( fim == -1 )
      ind = -1;
      v = ret;
      x = [];
   endif

endfunction

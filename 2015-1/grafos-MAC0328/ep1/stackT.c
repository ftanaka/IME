#include <stdio.h>
#include <stdlib.h>

#include "stack.h"

int main ( void ) {
   stack *pilha;
   arc *arco;
   int i;

   pilha = NULL;
   arco = NULL;

   printf ( "# Teste 1 - STACK_end ( null )\n" );
   pilha = STACK_end ( pilha );
   printf ( "# Fim Teste 1\n" );

   printf ( "# Teste 2 - STACK_push ( null )\n" );
   STACK_push ( pilha, 0, 1 );
   printf ( "# Fim Teste 2\n" );

   printf ( "# Teste 3 - STACK_pop ( null )\n" );
   arco = STACK_pop ( pilha );
   if ( arco == NULL )
      printf ( "## SUCESSO\n" );
   else
      printf ( "## FALHA\n" );
   printf ( "# Fim Teste 3\n" );

   printf ( "# Teste 4 - STACK_new ( 5 )\n" );
   pilha = STACK_new ( 5 );
   if ( pilha != NULL )
      printf ( "## SUCESSO\n" );
   else
      printf ( "## FALHA\n" );
   printf ( "# Fim Teste 4\n" );

   printf ( "# Teste 5 - STACK_pop ( empty )\n");
   arco = STACK_pop ( pilha );
   if ( arco == NULL )
      printf ( "## SUCESSO\n" );
   else
      printf ( "## FALHA\n" );
   printf ( "# Fim Teste 5\n" );

   printf ( "# Teste 6 - STACK_print ( empty )\n" );
   STACK_print ( pilha );
   printf ( "# Fim Teste 6\n" );

   printf ( "# Teste 7 - STACK_push ( pilha, 0, 1 )\n" );
   STACK_push ( pilha, 0, 1 );
   STACK_print ( pilha );
   printf ( "# Fim Teste 7\n" );

   printf ( "# Teste 8 - STACK_pop ( pilha )\n" );
   arco = STACK_pop ( pilha );
   if ( arco->u == 0 && arco->v == 1 )
      printf ( "## SUCESSO\n" );
   else
      printf ( "## FALHA\n" );
   STACK_print ( pilha );
   printf ( "# Fim Teste 8\n" );

   printf ( "# Teste 9 - 7 x STACK_push ( pilha, i, i + 1 )\n" );
   for ( i = 0; i < 7; i++ )
      STACK_push ( pilha, i, i + 1 );
   STACK_print ( pilha );
   printf ( "# Fim Teste 9\n" );

   printf ( "# Teste 10 - 7 x STACK_pop ( pilha )\n" );
   for ( i = 0; i < 7; i++ ) {
      arco = STACK_pop ( pilha );
      if ( i >= 5 ) {
         if ( arco == NULL )
            printf ( "## SUCESSO\n" );
         else
            printf ( "## FALHA\n" );
      } else {
         if ( arco->u == 4 - i && arco->v == 5 - i  )
            printf ( "## SUCESSO\n" );
         else
            printf ( "## FALHA\n" );
      }
   }
   printf ( "# Fim Teste 10\n" );

   printf ( "# Teste 11 - STACK_end ( pilha )\n" );
   pilha = STACK_end ( pilha );
   if ( pilha == NULL )
      printf ( "## SUCESSO\n" );
   else
      printf ( "## FALHA\n" );
   printf ( "# Fim Teste 11\n" );

   return 0;
}

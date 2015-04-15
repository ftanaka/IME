#include <stdio.h>
#include <stdlib.h>

#include "stack.h"

int main ( void ) {
   stack *pilha;
   arc *arco;

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

   return 0;
}

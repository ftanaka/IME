#include <stdio.h>
#include <stdlib.h>

#include "stack.h"

stack *STACK_new ( int tamanho ) {
   stack *novo;
   int i;

   novo = NULL;

   if ( tamanho <= 0 )
      fprintf ( stderr, "ERROR: invalid size value: STACK_new\n" );
   else {
      novo = malloc ( sizeof ( stack ) );
      if ( novo == NULL )
         fprintf ( stderr, "ERROR: malloc failed: STACK_new:novo\n" );
      else {
         novo->array = malloc ( tamanho * sizeof ( arc ) );
         if ( novo->array == NULL ) {
            fprintf ( stderr, "ERROR: malloc failed: STACK_new:array\n" );
            novo = STACK_end ( novo );
         } else {
            novo->size = tamanho;
            novo->top  = 0;
            for ( i = 0; i < tamanho; i++ )
               novo->array[i].u = novo->array[i].v = -1;
         }
      }
   }

   return novo;
}

void STACK_push ( stack *pilha, int u, int v ) {
   if ( pilha == NULL )
      fprintf ( stderr, "ERROR: null pointer to stack: STACK_push\n" );
   else if ( pilha->array == NULL )
      fprintf ( stderr, "ERROR: null pointer to array: STACK_push\n" );
   else if ( pilha->top == pilha->size )
      fprintf ( stderr, "ERROR: stack is full: STACK_push\n" );
   else {
      pilha->array[pilha->top].u = u;
      pilha->array[pilha->top].v = v;
      pilha->top++;
   }
}

arc *STACK_pop ( stack *pilha ) {
   arc *value;

   value = NULL;

   if ( pilha == NULL )
      fprintf ( stderr, "ERROR: null pointer to stack: STACK_pop\n" );
   else if ( pilha->array == NULL )
      fprintf ( stderr, "ERROR: null pointer to array: STACK_pop\n" );
   else if ( pilha->top == 0 )
      fprintf ( stderr, "ERROR: stack is empty: STACK_pop\n" );
   else
      value = &pilha->array[--pilha->top];

   return value;
}

stack *STACK_end ( stack *pilha ) {
   if ( pilha == NULL )
      fprintf ( stderr, "ERROR: null pointer to stack: STACK_end\n" );
   else {
      if ( pilha->array != NULL )
         free ( pilha->array );
      free ( pilha );
   }
   return NULL;
}

void STACK_print ( stack *pilha ) {
   int i;

   if ( pilha == NULL )
      fprintf ( stderr, "ERROR: null pointer to stack: STACK_print\n" );
   else if ( pilha->array == NULL )
      fprintf ( stderr, "ERROR: null pointer to array: STACK_print\n" );
   else {
      fprintf ( stdout, "STACK_print\n" );
      fprintf ( stdout, "  stack->size = %d\n", pilha->size );
      fprintf ( stdout, "  stack->top  = %d\n", pilha->top  );
      fprintf ( stdout, "  BOTTOM ->" );
      for ( i = 0; i < pilha->top; i++ )
         fprintf (stdout, " ( %d, %d )", pilha->array[i].u, pilha->array[i].v);
      fprintf ( stdout, " TOP\n" );
   }
}

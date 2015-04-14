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

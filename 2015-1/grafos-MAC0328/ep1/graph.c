#include <stdio.h>
#include <stdlib.h>

#include "graph.h"

graph *GRAPH_new ( int tamanho ) {
   graph *novo;

   novo = NULL;

   if ( tamanho <= 0 )
      fprintf ( stderr, "ERROR: invalid size value: GRAPH_new\n" ):
   else {
      novo = malloc ( sizeof ( graph ) );
      if ( novo == NULL )
         fprintf ( stderr, "ERROR: malloc failed: GRAPH_new\n" );
      else {
         novo->V = tamanho;
         novo->E = 0;
         novo->array = NODE_new ( tamanho );
      }
   }

   return novo;
}

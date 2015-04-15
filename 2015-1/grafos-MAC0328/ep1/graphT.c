#include <stdio.h>
#include <stdlib.h>

#include "graph.h"

int main ( void ) {
   graph *grafo;
   arc   *arco;

   grafo = NULL;
   arco  = NULL;

   grafo = GRAPH_input ();
   GRAPH_print ( grafo );

   return 0;
}

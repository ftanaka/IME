#include <stdio.h>
#include <stdlib.h>

#include "graph.h"

int main ( void ) {
   graph *grafo;
   arc   *arco;

   grafo = NULL;
   arco  = NULL;

   printf ( "# TESTE 1 - GRAPH_input\n" );
   grafo = GRAPH_input ();
   GRAPH_print ( grafo );
   printf ( "# FIM TESTE 1\n" );

   printf ( "# ULTIMO TESTE - GRAPH_end ( grafo )\n" );
   grafo = GRAPH_end ( grafo );
   printf ( "# FIM ULTIMO TESTE\n" );

   return 0;
}

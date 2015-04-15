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
         if ( novo->array == NULL )
            novo = GRAPH_end ( novo );
      }
   }

   return novo;
}

node *NODE_new ( int tamanho ) {
   node *novo;

   novo = NULL;

   if ( tamanho <= 0 )
      fprintf ( stderr, "ERROR: invalid size value: NODE_new\n" );
   else {
      novo = malloc ( tamanho * sizeof ( node ) );
      if ( novo == NULL )
         fprintf ( stderr, "ERROR: malloc failed: NODE_new\n" );
      else
         for ( i = 0; i < tamanho; i++ ) {
            novo[i].vertex = i;
            novo[i].degree = 0;
            novo[i].list   = NULL;
         }
   }

   return novo;
}

arc *ARC_new ( int vertice ) {
   arc *novo;

   novo = malloc ( sizeof ( arc ) );
   if ( novo == NULL )
      fprintf ( stderr, "ERROR: malloc failed: ARC_new\n" );
   else {
      novo->vertex = vertice;
      novo->block  = -1;
   }

   return novo;
}

graph *GRAPH_end ( graph *grafo ) {
   if ( grafo == NULL )
      fprintf ( stderr, "ERROR: null pointer to graph: GRAPH_end\n" );
   else {
      if ( grafo->array != NULL )
         grafo->array = NODE_end ( grafo->array, grafo->V );
      free ( grafo )
      grafo = NULL;
   }
   return grafo;
}

node *NODE_end ( node *vetor, int tamanho ) {
   if ( vetor == NULL )
      fprintf ( stderr, "ERROR: null pointer to array: NODE_end\n" );
   else {
      for ( i = 0; i < tamanho; i++ )
         if ( vetor[i].list != NULL )
            vetor[i].list = ARC_end ( vetor[i].list );
      free ( vetor );
      vetor = NULL;
   }
   return vetor;
}

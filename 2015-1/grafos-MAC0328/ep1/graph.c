#include <stdio.h>
#include <stdlib.h>

#include "graph.h"

graph *GRAPH_new ( int tamanho ) {
   graph *novo;

   novo = NULL;

   if ( tamanho <= 0 )
      fprintf ( stderr, "ERROR: invalid size value: GRAPH_new\n" );
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
   int i;

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
      free ( grafo );
      grafo = NULL;
   }
   return grafo;
}

node *NODE_end ( node *vetor, int tamanho ) {
   int i;

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

arc *ARC_end ( arc *arco ) {
   arc *ptr;

   if ( arco != NULL ) {
      ptr = arco->next;
      free ( arco );
      return ARC_end ( ptr );
   } else
      return arco;
}

void ARC_add ( graph *grafo, int u, int v ) {
   arc *novo, *ptr;

   novo = ptr = NULL;

   if ( grafo == NULL )
      fprintf ( stderr, "ERROR: null pointer to graph: ARC_add\n" );
   else if ( grafo->array == NULL )
      fprintf ( stderr, "ERROR: null pointer to array: ARC_add\n" );
   else if ( u < 0 && u >= grafo->V )
      fprintf ( stderr, "ERROR: invalid u-vertex: ARC_add\n" );
   else if ( v < 0 && v >= grafo->V )
      fprintf ( stderr, "ERROR: invalid v-vertex: ARC_add\n" );
   else {
      novo = ARC_new ( v );
      if ( novo == NULL ) return;
      if ( grafo->array[u].list == NULL )
         grafo->array[u].list = novo;
      else {
         for ( ptr = grafo->array[u].list; ptr != NULL && ptr->next != NULL;
               ptr = ptr->next);
         ptr->next = novo;
      }
      grafo->E++;
      grafo->array[u].degree++;
   }
}

graph *GRAPH_input ( void ) {
   int tamanho, grau, v, flag, i, j;
   graph *grafo;

   tamanho = grau = v = flag = i = j = 0;
   grafo = NULL;

   fscanf ( stdin, "%d", &tamanho );
   if ( tamanho <= 0 )
      fprintf ( stderr, "ERROR: invalid size value: GRAPH_input\n" );
   else {
      grafo = GRAPH_new ( tamanho );
      if ( grafo != NULL ) {
         for ( i = 0; i < tamanho; i++ ) {
            fscanf ( stdin, "%d", &grau );
            for ( j = 0; j < grau; j++ ) {
               fscanf ( stdin, "%d", &v );
               if ( v < 0 && v >= tamanho ) {
                  fprintf ( stderr, "ERROR: invalid vertex: GRAPH_input\n" );
                  flag = 1;
               } else
                  ARC_add ( grafo, i, v );
            }
         }
      }
   }

   if ( flag == 1 )
      grafo = GRAPH_end ( grafo );

   return grafo;
} 

void GRAPH_print ( graph *grafo ) {
   arc *ptr;
   int i;

   fprintf ( stdout, "GRAPH_print\n" );
   fprintf ( stdout, "  V = %d\n", grafo->V );
   fprintf ( stdout, "  E = %d\n", grafo->E );
   for ( i = 0; i < grafo->V; i++ ) {
      fprintf ( stdout, "  %d", grafo->array[i].degree );
      for ( ptr = grafo->array[i].list; ptr != NULL; ptr = ptr->next )
         fprintf ( stdout, " %d", ptr->vertex );
      fprintf ( stdout, "\n" );
   }
}

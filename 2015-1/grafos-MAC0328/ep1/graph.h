typedef struct GRAPH graph;

typedef struct NODE node;

typedef struct ARC arc;

struct GRAPH {
   int V;
   int E;
   node *array;
};

struct NODE {
   int vertex;
   int degree;
   arc *list;
};

struct ARC {
   int vertex;
   int block;
   arc *next;
};

graph *GRAPH_new ( int );

node *NODE_new ( int );

arc *ARC_new ( int );

graph *GRAPH_end ( graph * );

node *NODE_end ( node *, int );

arc *ARC_end ( arc * );

void ARC_add ( graph *, int, int );

graph *GRAPH_input ( void );

void GRAPH_print ( graph * );

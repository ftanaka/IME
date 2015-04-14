typedef struct STACK {
   int size;
   int top;
   arc *array;
}arc;

typedef struct ARC {
   int u;
   int v;
}arc;

stack *STACK_new ( int );

void STACK_push ( stack *, int, int );

stack *STACK_pop ( stack * );

void STACK_end ( stack * );

void STACK_print ( stack * );

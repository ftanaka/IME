typedef struct STACK {
   int size;
   int top;
   arc *array;
}stack;

typedef struct ARC {
   int u;
   int v;
}arc;

stack *STACK_new ( int );

void STACK_push ( stack *, int, int );

arc *STACK_pop ( stack * );

stack *STACK_end ( stack * );

void STACK_print ( stack * );

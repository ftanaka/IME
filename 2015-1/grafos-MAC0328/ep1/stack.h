typedef struct STACK {
   int u;
   int v;
}stack;

stack *STACK_new ( int );

void STACK_push ( stack *, int, int );

stack *STACK_pop ( stack * );

void STACK_end ( stack * );

void STACK_print ( stack * );

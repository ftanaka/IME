CC = gcc
CFLAGS = -Wall -pedantic -ansi -std=c99 -g

all: compila testes

compila: stack.o graph.o

stack.o: stack.c
	$(CC) $(CFLAGS) -c $^

graph.o: graph.c
	$(CC) $(CFLAGS) -c $^

testes: testeS testeG

testeS: stack.o stackT.c
	$(CC) $(CFLAGS) $^ -o $@

testeG: graph.o graphT.c
	$(CC) $(CFLAGS) $^ -o $@

.PHONY: clear
clear:
	rm -rf *.o teste*

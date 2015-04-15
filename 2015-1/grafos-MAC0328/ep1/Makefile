CC = gcc
CFLAGS = -Wall -pedantic -ansi -std=c99 -g

all: compila testes

compila: stack.o

stack.o: stack.c
	$(CC) $(CFLAGS) -c $^

testes:testeS

testeS: stack.o stackT.c
	$(CC) $(CFLAGS) $^ -o $@

.PHONY: clear
clear:
	rm -rf *.o testeS*

CC = gcc
CFLAGS = -Wall -pedantic -ansi -std=c99 -g

all: compila

compila: stack.o

stack.o: stack.c
	$(CC) $(CFLAGS) -c $^

.PHONY: clear
clear:
	rm -rf *.o

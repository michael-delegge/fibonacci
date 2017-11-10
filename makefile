all: fibonacci

fibonacci: fibonacci.o
	gcc fibonacci.o -o fibonacci

fibonacci.o: fibonacci.s
	nasm -f elf64 fibonacci.s

clean:
	rm -f *.o fibonacci

all: fibonacci

fibonacci: fibonacci.o
	gcc fibonacci.o -s -o fibonacci

fibonacci.o: fibonacci.asm
	nasm -felf64 fibonacci.asm

clean:
	rm -f *.o fibonacci

all:
	flex lex.l
	gcc lex.yy.c
	./a.out
	cat output.txt

compile:
	flex lex.l
	gcc lex.yy.c

clean:
	rm a.out
	rm lex.yy.c
	rm output.txt
	
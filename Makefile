all:
	flex lexer.l
	bison -d yacc.y
	cc lex.yy.c yacc.tab.c
	./a.out < output.txt

file:
	flex lex.l
	cc lex.yy.c
	./a.out
	cat output.txt

flex:
	flex lexer.l

bison:
	bison -d yacc.y

compile:
	cc lex.yy.c yacc.tab.c

clean:
	rm a.out
	rm yacc.tab.c
	rm yacc.tab.h
	rm lex.yy.c
	rm output.txt
	
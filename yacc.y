%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(char *err);
int yylex();
int yyparse();
int yywrap() { return 1; }

int main() { yyparse(); }
%}

%token PROGRAM
%token VAR
%token BEGIN
%token INTEGER
%token PRINT
%token END

%token OPEN_PARENTHESIS
%token CLOSED_PARENTHESIS
%token PLUS
%token DIVIDE
%token TIMES
%token OPERATOR

%token <number> STATE DIGIT
%token <string> LETTER IEDENTIFIER STRING
%type <string> pname id dec print output
%type <number> assign expr term factor

%union {
    int number;
    char *string;
}

%locations
%%
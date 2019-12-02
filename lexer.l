%{
#include <stdio.h>
#include <string.h>
%}
%option yylineno
%%

PROGRAM                 { return PROGRAM; }
VAR                     { return VAR; }
BEGIN                   { return BEGIN; }
PRINT                   { return PRINT; }
INTEGER                 { return INTEGER; }
"END."                  { return END; }

;                       { return COLON; }
:                       { return SEMICOLON; }
=                       { return ASSIGNMENT; }
"+"                     { return PLUS; }
"-"                     { return MINUS; }
"/"                     { return DIVIDE; }
"*"                     { return TIMES; }
"("                     { return OPEN_PARENTHESIS; }
")"                     { return CLOSED_PARENTHESIS; }

[0-9]+                  yylval.number=atoi(yytext); return DIGIT;
[a-zA-Z_][a-zA-Z0-9]*   yylval.string = strdup(yytext); return IDENTIFIER;
'.*'|[ \t]+|\n          ;
%%

void yyerror(char *err)
{
    fprintf(stderr, "Error: %s on line: %d.\n", err, yylineno);
}
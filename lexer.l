%{
#include <stdio.h>
#include <string.h>
#include "yacc.tab.h"
%}
%option yylineno
%%

PROGRAM                 return PROGRAM;
VAR                     return VAR;
BEGIN                   return BEG;
PRINT                   return PRINT;
INTEGER                 return INTEGER;
\"(\(.|\n)|[^\\"\n])*\" return STRING;
"END."                  return END;
:                       return COLON;
;                       return SEMICOLON;
=                       return ASSIGNMENT;
"+"                     return PLUS;
"-"                     return MINUS;
"/"                     return DIVIDE;
"*"                     return TIMES;
"("                     return OPAREN;
")"                     return CPAREN;
","                     return COMMA;
\‘                      return OQUOTE;
\’                      return CQUOTE;

[0-9]+                  yylval.number=atoi(yytext); return DIGIT;
[a-zA-Z_][a-zA-Z0-9]*   yylval.string = strdup(yytext); return IDENTIFIER;
'.*'|[ \t]+|\n          ;
%%

void yyerror(char *err)
{
    fprintf(stderr, "Error: %s on line: %d.\n", err, yylineno);
}
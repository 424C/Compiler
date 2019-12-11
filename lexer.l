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
"END."                  return END;
:                       return COLON;
;                       return SEMICOLON;
=                       return EQUALS;
"+"                     return PLUS;
"-"                     return MINUS;
"/"                     return DIVIDE;
"*"                     return TIMES;
"("                     return OPAREN;
")"                     return CPAREN;
","                     return COMMA;
'(\\.|[^\\'])*'     { 
                      int len = strlen(yytext); 
                      yytext[0] = '\"'; 
                      yytext[len - 1] = '\"'; 
                      yylval.str = strdup(yytext); 
                      return QUOTE;
                    }  
\‘                      return OQUOTE;
\’                      return CQUOTE;

[0-9]+                  yylval.str = strdup(yytext); return number;
[a-f][a-f0-9_]*   yylval.str = strdup(yytext); return IDENTIFIER;
'.*'|[ \t]+|\n          ;
%%

void yyerror(char *err)
{
    fprintf(stderr, "ERROR LINE %d: %s\n", yylineno, err);
}
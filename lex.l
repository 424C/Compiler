%{
#include<stdio.h>
%}

comment                                     \(\*\s*.*\n*.*\n*.*\n*.*\*\)
id                                          [a-zA-Z_][a-zA-Z0-9]*
letter                                      [a-zA-Z]
number                                      [0-9]+
operator                                    [-+*/]
equal                                       [=]

comma                                       [,]
open_parenth                                [(]
closed_parenth                              [)]
colon                                       [:]
semicolon                                   [;]
string                                      \'.*\'




%%
"PROGRAM"                                       { fprintf(yyout, "%s ", yytext); }
"VAR"                                           { fprintf(yyout, "%s\n", yytext); }
"INTEGER"                                       { fprintf(yyout, "%s", yytext); }
"BEGIN"                                         { fprintf(yyout, "%s\n", yytext); }
"PRINT"                                         { fprintf(yyout, "%s", yytext); }
"END."                                          { fprintf(yyout, "%s\n", yytext); }

{id}                                            { fprintf(yyout, "%s ", yytext); }
{equal}                                         { fprintf(yyout, "%s ", yytext); }
{operator}                                      { fprintf(yyout, "%s ", yytext); }
{number}                                        { fprintf(yyout, "%s ", yytext); }

{open_parenth}                                  { fprintf(yyout, "%s ", yytext); }
{closed_parenth}                                { fprintf(yyout, "%s ", yytext); }
{semicolon}                                     { fprintf(yyout, "%s\n", yytext); }
{comma}                                         { fprintf(yyout, "%s ", yytext); }
{colon}                                         { fprintf(yyout, "%s ", yytext); }
{string}                                        { fprintf(yyout, "%s ", yytext); }

.|\n|{comment} ;

%%
int main()
{
    yyin = fopen("final.txt", "r");
    yyout = fopen("output.txt", "w");
    yylex();
    fclose(yyin);
    fclose(yyout);
}

int yywrap(void) {
    return 1;
}
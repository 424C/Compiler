%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *err);
//int yylex();
// int yyparse();
extern int yylineno;
int yywrap() { return 1; }
void push_identifiers(char *);
void print_identifiers();
void check_identifier(char *);

FILE * pfile;
char identifiers[14][10];
int identifier_count=0;
%}

//Various keywords
%token PROGRAM
%token VAR
%token BEG
%token PRINT
%token END

//operator tokens
%token EQUALS
%token PLUS
%token MINUS
%token DIVIDE
%token TIMES
%token OPERATOR

//character tokens
%token COLON
%token OPAREN
%token CPAREN
%token SEMICOLON
%token COMMA
%token OQUOTE
%token CQUOTE


%token <str> IDENTIFIER QUOTE INTEGER number
%type <str> assign output stat_list stat pname dec print
%type <str> type term expr factor
%left '-' '+'
%right '*' '/'
%union {
    char *str;
    int num;
}
%start start

%%

start: PROGRAM pname SEMICOLON VAR dec_list SEMICOLON BEG stat_list end { printf("success\n"); }
    |   { yyerror("keyword 'PROGRAM' expected."); exit(1); }
    ;

pname: IDENTIFIER  { printf("pname  \n"); $$ = $1; }
    |   { yyerror("program name expected."); exit(1); }
    ;

dec_list: dec COLON type    { printf("dec_list  \n"); } { print_identifiers(); }
    |   dec type { yyerror(": expected"); exit(1); }
    ;

dec:    IDENTIFIER COMMA dec    { printf("dec [%s]\n", $3); } { push_identifiers($1); } 
    |   IDENTIFIER   { printf("identifier [%s]\n", $1); } { $$ = $1; push_identifiers($1);}
    ;

type: INTEGER { printf("integer  \n"); $$ = $1; }
    |   { yyerror("keyword 'INTEGER' expected."); exit(1); }
    ;

begin: BEG  { printf("BEGIN  \n"); }
    |   { yyerror("keyword 'BEGIN' expected."); exit(1); }
    ;

stat_list: stat SEMICOLON   { printf("stat ;  \n"); $$ = $1; }
    | stat SEMICOLON stat_list  { printf("stat ; stat_list  \n"); $$ = $1; }
    | stat { yyerror("; expected"); exit(1); }
    ;

stat:  print     { printf("stat  \n"); $$ = $1; fprintf(pfile, ";\n"); }
    |  assign    { printf("assign value=%d\n",$1); $$ = $1; fprintf(pfile, ";\n"); }
    ;

print:   PRINT OPAREN output CPAREN   { printf("print  \n"); $$ = $3; }
    | PRINT output CPAREN { yyerror("( expected"); exit(1);}
    | PRINT OPAREN output { yyerror(") expected"); exit(1);}
    ;

output: IDENTIFIER { printf("output id  \n"); check_identifier($1); fprintf(pfile, "cout << %s << endl", $1); }
    |   QUOTE COMMA IDENTIFIER { printf("string , id  \n"); fprintf(pfile, "cout << %s << %s << endl", $1, $3); }
    ;

assign: IDENTIFIER EQUALS expr { printf("assign   $1=%s $3=%d\n",$1,$3); check_identifier($1);}  { fprintf(pfile, " %s = %s", $1, $3); } 
    |   IDENTIFIER expr { yyerror("operator '=' expected"); }
    |   { yyerror("assignment failed."); exit(1); }
    ;

expr:  term         { printf("expr term  \n"); $$ = $1; }
    | expr PLUS term { printf("expr + term  \n"); $$ = $1; strcat($$, " + "); strcat($$, $3); }
    | expr MINUS term { printf("expr - term  \n"); $$ = $1; strcat($$, " - "); strcat($$, $3); }
    | { yyerror("= expected"); exit(1);}
    ;

term:   term TIMES factor { printf("term * factor  \n"); $$ = $1; strcat($$, " * "); strcat($$, $3); }
    |   term DIVIDE factor { printf("term / factor  \n"); $$ = $1; strcat($$, " / "); strcat($$, $3);}
    |   factor          { printf("factor  \n"); $$ = $1;}
    ;

factor: IDENTIFIER         { printf("factor id  \n"); $$ = $1; check_identifier($1); }
    |   number      { printf("factor number  \n"); $$ = $1;  }
    |   OPAREN expr CPAREN { printf("( expr )  \n"); $$ = $2; }
    |   expr OPAREN { yyerror("cparen expected"); exit(1);}
    |   CPAREN expr { yyerror("oparen expected"); exit(1);}
    ;

end: END { printf("END.  \n"); }
    |   { yyerror("keyword 'END.' expected."); exit(1); }
    ;

%%
int main() 
{ 
    
    pfile=fopen("abc13.cpp", "w");
    if(!pfile)
    {
        perror("Error opening file.\n");
    }
    else
    {
        fprintf(pfile, "#include <iostream>\nusing namespace std;\nint main()\n{\n");
    }
    
    yyparse();

    fprintf(pfile, "\n return 0;\n}");
    fclose(pfile);
}

void push_identifiers(char * str)
{
    strcpy(identifiers[identifier_count], str);
    identifier_count++;
    printf("Calling push_identifiers %s\n", identifiers[identifier_count]);
}

void print_identifiers()
{
    int i;
    fprintf(pfile, " int ");
    for(i=identifier_count-1; i>0; i--)
    {
        fprintf(pfile, "%s, ", identifiers[i]);
    }
    fprintf(pfile, "%s;\n", identifiers[0]);
}

void check_identifier(char * str)
{
    int isValid=1;
    for(int i=0; i<identifier_count; i++)
    {
        if(strcmp(identifiers[i], str)==0)
        {
            isValid=0;
        }
    }

    if(isValid==1)
    {
        yyerror(strcat(str, " unknown identifier"));
        exit(1);
    }
}
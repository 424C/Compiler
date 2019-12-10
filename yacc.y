%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *err);
int yylex();
int yyparse();
int yywrap() { return 1; }
void push_identifiers(char *);
void print_identifiers();

FILE * pfile;
char identifiers[14][10];
int identifier_count=0;
// int main() { yyparse(); }
%}

//Various keywords
%token PROGRAM
%token VAR
%token BEG
%token INTEGER
%token PRINT
%token END

//operator tokens
%token ASSIGNMENT
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
%token STRING


%token <number> STATE DIGIT
%token <string> LETTER IDENTIFIER
%type <string> pname id dec print output string
%type <number> assign expr term factor

%union {
    int number;
    char *string;
}

%locations
%%

start: PROGRAM pname semicolon var dec_list semicolon begin stat_list end { printf("start completed\n"); }
    |   { yyerror("keyword 'PROGRAM' expected."); exit(1); }
    ;

pname: id  { printf("pname returning\n"); }
    |   { yyerror("program name expected."); exit(1); }
    ;

id: IDENTIFIER { printf("id returning: [%s]\n", $1); }
    ;

var: VAR   { printf("var returning\n"); }
    |   { yyerror("keyword 'VAR' expected."); exit(1); }
    ;

dec_list: dec colon type    { printf("dec_list returning\n"); } { print_identifiers(); }
    ;

dec:    IDENTIFIER comma dec    { printf("dec [%s]\n", $3); } { push_identifiers($1); }
    |   IDENTIFIER IDENTIFIER   { yyerror("two identifiers without comma. ',' expected."); exit(1); }
    |   IDENTIFIER   { printf("identifier [%s]\n", $1); } { $$ = $1; push_identifiers($1);}
    ;

colon: COLON   { printf("colon returning\n"); }
    |   { yyerror("':' missing."); exit(1); }
    ;

semicolon: SEMICOLON   { printf("semicolon returning\n"); }
    |   { yyerror("';' missing."); exit(1); }
    ;

type: INTEGER   { printf("integer returning\n"); }
    |   { yyerror("keyword 'INTEGER' expected."); exit(1); }
    ;

begin: BEG  { printf("BEGIN returning\n"); }
    |   { yyerror("keyword 'BEGIN' expected."); exit(1); }
    ;

stat_list: stat semicolon   { printf("stat ; returning\n"); }
    | stat semicolon stat_list  { printf("stat ; stat_list returning\n"); }
    ;

stat:  print     { printf("stat returning\n"); }
    |  assign    { printf("assign value=%d\n",$1); }
    ;

print:   PRINT oparen output cparen   { printf("print returning\n");}
    ;

oparen: OPAREN { printf("open paren returning\n"); }
    |   { yyerror("'(' missing."); exit(1); }
    ;

cparen: CPAREN { printf("close paren returning\n"); }
    |   { yyerror("')' missing."); exit(1); }
    ;

output: id  { printf("output id returning\n"); }
    |   string comma id { printf("string , id returning\n"); }
    ;

string: STRING { printf("string returning\n"); fflush(stdin); }
    |   { yyerror("invalid string format."); exit(1); }
    ;

comma: COMMA { printf("comma returning\n"); }
    |   { yyerror("',' expected."); exit(1); }
    ;

assign: id assignment expr { printf("assign returning $1=%s $3=%d\n",$1,$3); $$ = $3; }
    |   { yyerror("assignment failed."); exit(1); }
    ;

assignment: ASSIGNMENT { printf("assignment returning\n"); }
    |   { yyerror("operator '=' missing."); exit(1); }
    ;

expr:  term         { printf("expr term returning\n"); }
    | expr PLUS term { printf("expr + term returning\n"); $$ = $1 + $3; }
    | expr MINUS term { printf("expr - term returning\n"); }
    ;

term:   term TIMES factor { printf("term * factor returning\n"); $$ = $1 * $3; }
    |   term DIVIDE factor { printf("term / factor returning\n"); }
    |   factor          { printf("factor returning\n"); }
    ;

factor: id          { printf("factor id returning\n"); }
    |   number      { printf("factor number returning\n"); }
    |   '(' expr ')'{ printf("( expr ) returning\n"); }
    ;

number: DIGIT   { printf("number DIGIT returning\n"); }
    ;

end: END { printf("END. returning\n"); }
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
    printf("print_identifiers is called\n");
    int i;
    fprintf(pfile, " int ");
    for(i=0; i<identifier_count-1; i++)
    {
        fprintf(pfile, "%s, ", identifiers[i]);
    }
    fprintf(pfile, "%s;", identifiers[identifier_count-1]);
}
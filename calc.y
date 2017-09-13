%{
#include <math.h>
#include <stdio.h>
#define YYSTYPE double
int yyerror (char const *s);
extern int yylex (void);
%}

%token NUMBER
%token PLUS MINUS TIMES DIVIDE POWER
%token LEFT RIGHT
%token END

%left PLUS MINUS
%left TIMES DIVIDE
%left NEG
%right POWER

%error-verbose
%start Input
%%

Input: /* empty */;
Input: Input Line;

Line: END
Line: Expression END { printf("Result: %f\n", $1); }

Expression: NUMBER { $$=$1; };
Expression: Expression PLUS Expression { $$ =$1 + $3; };
Expression: Expression MINUS Expression { $$ = $1 - $3; };
Expression: Expression TIMES Expression { $$ = $1 * $3; };
Expression: Expression DIVIDE Expression { $$ = $1 / $3; };
Expression: MINUS Expression %prec NEG { $$ = -$2; };
Expression: Expression POWER Expression { $$ = pow($1, $3); };
Expression: LEFT Expression RIGHT { $$ = $2; };

%%

int yyerror(char const *s) {
  printf("%s\n", s);
}

int main() {
    int ret = yyparse();
    if (ret){
	fprintf(stderr, "%d error found.\n",ret);
    }
    return 0;
}


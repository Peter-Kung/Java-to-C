/* j_lex.h */

extern FILE *yyin;
extern FILE *yyout;
extern int yylex();
extern int yyparse();
extern int yyerror(char *);

extern void print_lex( int );


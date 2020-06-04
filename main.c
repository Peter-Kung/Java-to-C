#include <stdio.h>
#include "j_lex.h"
#include "j_tree.h"
#include "j_parse.h"

char name[16];
jSTM* program = NULL;

int main(int argc,char *argv[]) {
    int t;

    yyin = fopen(argv[1],"r");
    for(t=0; (t<13) && (argv[1][t]!='\0') && (argv[1][t]!='.'); t++)
	name[t] = argv[1][t];
    name[t++] = '.';
    name[t++] = 'c';
    name[t++] = '\0';
    yyout = fopen(name, "w");

    yyparse();
    print_stm( program );
    fprintf(stderr, "j2c compiles %s into %s!\n", argv[1], name);
    free_stm( program );
}

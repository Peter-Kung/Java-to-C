%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "j_lex.h"
	#include "j_tree.h"
	#include "j_parse.h"
%}

%token CLASS PUB STATIC
%left  AND OR
%left  LT LE EQ
%left  ADD MINUS
%left  TIMES
%token LBP RBP LSP RSP LP RP
%token INT
%token IF ELSE
%token WHILE PRINT
%token ASSIGN
%token VOID MAIN STR
%token RETURN
%token SEMI COMMA
%token THIS NEW DOT
%token ID LIT TRUE FALSE
%token COMMENT

%union{ jSTM* sm;
	jEXP* ex;
	int   nu;
	char* sr;
      }

%type <sm> prog
%type <sm> mainc
%type <sm> cdcls
%type <sm> cdcl
%type <sm> vdcls
%type <sm> vdcl
%type <sm> mdcls
%type <sm> mdcl
%type <sm> stmts
%type <sm> stmt
%type <ex> formals
%type <ex> frest
%type <ex> type
%type <ex> exp
%type <ex> exps
%type <ex> erest
%type <nu> LIT
%type <sr> ID

%expect 30

%%
prog	:	mainc cdcls
		{ program = create_stm();
		  program->stm_id = sPROG;
		  program->stm1 = $1;
		  program->stm2 = $2;
		  $$ = program;
		}
	|
		{ program = NULL;
		  $$ = program;
		  printf("****** Parsing failed!\n");
		}
	;

mainc	:	CLASS ID LBP PUB STATIC VOID MAIN LP STR LSP RSP ID RP LBP stmts RBP RBP
		{ $$ = create_stm();
		  $$->stm_id = sMAINC;
		  $$->exp1 = create_exp();
		  $$->exp1->exp_id = eID;
		  strcpy($$->exp1->name, $2);
		  $$->exp2 = create_exp();
		  $$->exp2->exp_id = eID;
		  strcpy($$->exp2->name, $12);
		  $$->stm1 = $15;
		}
	;

cdcls	:	cdcl cdcls
		{ $$ = create_stm();
		  $$->stm_id = sCDCLS;
		  $$->stm1 = $1;
		  $$->stm2 = $2;
		}
	|
		{ $$ = NULL;
		}
	;

cdcl	:	CLASS ID LBP vdcls mdcls RBP
		{ $$ = create_stm();
		  $$->stm_id = sCDCL;
		  $$->exp1 = create_exp();
		  $$->exp1->exp_id = eID;
		  strcpy($$->exp1->name, $2);
		  $$->stm1 = $4;
		  $$->stm2 = $5;
		}
	;

vdcls	:	vdcl vdcls
		{ $$ = create_stm();
		  $$->stm_id = sVDCLS;
		  $$->stm1 = $1;
		  $$->stm2 = $2;
		}
	|
		{ $$ = NULL;
		}
	;

vdcl	:	type ID SEMI
		{ $$ = create_stm();
		  $$->stm_id = sVDCL;
		  $$->exp1 = $1;
		  strcpy($$->exp1->name, $2);
		}
	;

mdcls	:	mdcl mdcls
		{ /* Write the code here! */
		  $$ = create_stm();
		  $$->stm_id = sMDCLS;
		  $$->stm1 = $1;
		  $$->stm2 = $2;
		}
	|
		{ $$ = NULL;
		}
	;

mdcl	:	PUB type ID LP formals RP LBP vdcls stmts RETURN exp SEMI RBP
		{ /* Write the code here! */
		  $$ = create_stm();
		  $$->stm_id = sMDCL;
		  $$->exp1 = $2;
		  strcpy($$->exp1->name,$3);/*給function名字*/
		  $$->exp2 = $5;/*讓引數寫入*/
		  $$->stm1 = $8;
		  $$->stm2 = $9;
		  $$->stm3 = create_stm();
		  $$->stm3->exp1 = $11
		}
	;

formals	:	type ID frest
		{ $$ = create_exp();
		  $$->exp_id = eFORMALS;
		  $$->exp1 = $1;
		  strcpy($$->exp1->name, $2);
		  $$->next = $3;
		}
	|
		{ $$ = NULL;
		}
	;

frest	:	COMMA type ID frest
		{ $$ = create_exp();
		  $$->exp_id = eFREST;
		  $$->exp1 = $2;
		  strcpy($$->exp1->name, $3);
		  $$->next = $4;
		}
	|
		{ $$ = NULL;
		}
	;

type	:	INT LSP RSP
		{ /* Write the code here! */
			$$ = create_exp();
			$$->exp_id = tINTARR;
		}
	|	INT
		{ /* Write the code here! */
			$$ = create_exp();
			$$->exp_id = tINT;
		}
	|	ID
		{ /* Write the code here! */
		  $$ = create_exp();
		  $$->exp_id = tID;
		  strcpy($$->name,$1);
		}
	;

stmts	:	stmt stmts
		{ /* Write the code here! */
		  $$ = create_stm();
		  $$->stm_id = sSTMTS;
		  $$->stm1 = $1;
		  $$->stm2 = $2;
		}
	|
		{ /* Write the code here! */
		  $$ = NULL;
		}
	;

stmt	:	LBP stmts RBP
		{ /* Write the code here! */
		  $$ = create_stm();
		  $$->stm_id = sBSTMT;
		  $$->stm1 = $2;
		}
	|	IF LP exp RP stmt ELSE stmt
		{ /* Write the code here! */
		  $$ = create_stm();
		  $$->stm_id = sIF;
		  $$->exp1 = $3;
		  $$->stm1 = $5;
		  $$->stm2 = $7;
		}
	|	WHILE LP exp RP stmt
		{ /* Write the code here! */
		  $$ = create_stm();
		  $$->stm_id = sWHILE;
		  $$->exp1 = $3;
		  $$->stm1 = $5;
		}
	|	PRINT LP exp RP SEMI
		{ /* Write the code here! */
		  $$ = create_stm();
		  $$->stm_id = sPRINT;
		  $$->exp1 = $3;
		}
	|	ID ASSIGN exp SEMI
		{ /* Write the code here! */
			$$ = create_stm();
			$$->stm_id = sASSIGN;
			$$->exp1 = create_exp();
			$$->exp1->exp_id = eID;
			strcpy($$->exp1->name,$1);
			$$->exp2 = $3;
			
		}
	|	ID LSP exp RSP ASSIGN exp SEMI
		{ /* Write the code here! */
			$$ = create_stm();
			$$->stm_id = sARRASS;
			$$->exp1 = $3;
			strcpy($$->exp1->name,$1);
			$$->exp2 = $6;
		}
	|	vdcl
		{ /* Write the code here! */
			$$ = $1;
		}
	;

exp	:	exp ADD exp
		{ /* Write the code here! */
		  $$ = create_exp();
		  $$->exp_id = eADD;
		  $$->exp1 = $1;
		  $$->exp2 = $3;
		}
	|	exp MINUS exp
		{ /* Write the code here! */
		  $$ = create_exp();
		  $$->exp_id = eMINUS;
		  $$->exp1 = $1;
		  $$->exp2 = $3;
		}
	|	exp TIMES exp
		{ /* Write the code here! */
		  $$ = create_exp();
		  $$->exp_id = eTIMES;
		  $$->exp1 = $1;
		  $$->exp2 = $3;
		}
	|	exp AND exp
		{ /* Write the code here! */
		  $$ = create_exp();
		  $$->exp_id = eAND;
		  $$->exp1 = $1;
		  $$->exp2 = $3;
		}
	|	exp OR exp
		{ /* Write the code here! */
			$$ = create_exp();
			$$->exp_id = eOR;
			$$->exp1 = $1;
			$$->exp2 = $3;
		}
	|	exp LT exp
		{ /* Write the code here! */
	    	$$ = create_exp();
			$$->exp_id = eLT;
			$$->exp1 = $1;
			$$->exp2 = $3;
		}
	|	exp LE exp
		{ /* Write the code here! */
			$$ = create_exp();
			$$->exp_id = eLE;
			$$->exp1 = $1;
			$$->exp2 = $3;
		}
	|	exp EQ exp
		{ /* Write the code here! */
			$$ = create_exp();
			$$->exp_id = eEQ;
			$$->exp1 = $1;
			$$->exp2 = $3;
		}
	|	ID LSP exp RSP
		{ /* Write the code here! */
			$$ = create_exp();
			$$->exp_id = eARRELE;
			strcpy($$->name,$1);
			$$->exp1 = $3;
		}
	|	exp LP exps RP
		{ /* Write the code here! */
			$$ = create_exp();
			$$->exp_id = eFCALL;
			$$->exp1 = $1;
			$$->exp2 = $3;
		}
	|	LP exp RP
		{ /* Write the code here! */
			$$ = create_exp();
			$$->exp_id = ePAREN;
			$$->exp1 = $2;
		}
	|	exp DOT exp
		{ /* Write the code here! */
			$$ = create_exp();
			$$->exp_id = eDOTOBJ;
			$$->exp1 = $1;
			$$->exp2 = $3;
		}
	|	LIT
		{ /* Write the code here! */
			$$ = create_exp();
			$$->exp_id = eLIT;
			$$->val = $1;
		}
	|	ID
		{ /* Write the code here! */
			$$ = create_exp();
			$$->exp_id = eID;
			strcpy($$->name,$1);
		}
	|	THIS
		{ /* Write the code here! */
			$$ = create_exp();
			$$->exp_id = eTHIS;
		}
	|	NEW INT LSP exp RSP
		{ /* Write the code here! */
			$$ = create_exp();
			$$->exp_id = eNEWARR;
			$$->exp1 = $4;
		}
	|	NEW ID LP RP
		{ /* Write the code here! */
			$$ = create_exp();
			$$->exp_id = eNEW;
			strcpy($$->name,$2);
		}
	;

exps	:	exp erest
		{ /* Write the code here! */
			$$ = create_exp();
			$$->exp_id = eEXPS;
			$$->exp1 = $1;
			$$->exp2 = $2;
		}
	|
		{ /* Write the code here! */
			$$ = NULL;
		}
	;

erest	:	COMMA exp erest
		{ /* Write the code here! */
			$$ = create_exp();
			$$->exp_id = eEREST;
			$$->exp1 = $2;
			$$->exp2 = $3;
		}
	|
		{ /* Write the code here! */
			$$ = NULL;
		}
	;

%%

int yyerror(char *s)
{
	printf("%s\n",s);
	return 1;
}


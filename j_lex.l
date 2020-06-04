%{
#include "j_lex.h"
#include "j_tree.h"
#include "j_parse.h"
char sid[16];
int val;
%}

ID  [A-Za-z][A-Za-z0-9_]*
LIT [0-9][0-9]*
NONNL [^\n]

%%

class			{return CLASS;}
public			{return PUB;}
static			{return STATIC;}
String			{return STR;}
void			{return VOID;}
main			{return MAIN;}
System"."Out"."println	{return PRINT;}
int			{return INT;}
if			{return IF;}
else			{return ELSE;}
while			{return WHILE;}
new			{return NEW;}
return			{return RETURN;}
this			{return THIS;}
true			{return TRUE;}
false			{return FALSE;}
"&&"			{return AND;}
"||"			{return OR;}
"<"			{return LT;}
"<="			{return LE;}
"=="			{return EQ;}
"+"			{return ADD;}
"-"			{return MINUS;}
"*"			{return TIMES;}
"("			{return LP;}
")"			{return RP;}
"["			{return LSP;}
"]"			{return RSP;}
"{"			{return LBP;}
"}"			{return RBP;}
","			{return COMMA;}
";"			{return SEMI;}
"="			{return ASSIGN;}
"."			{return DOT;}
"//"{NONNL}*		{/* skip COMMENT */}
{ID}			{sscanf(yytext,"%s", sid);
			 yylval.sr = strdup( sid );
			 return ID;}
{LIT}			{sscanf(yytext,"%d", &val);
			 yylval.nu = val;
			 return LIT;}
[ \t\n]			{/* skip BLANK */}
.			{/* skip redundant characters */}

%%

int yywrap() {return 1;}



extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;
extern FILE *yyerr;

extern char name[16];
extern int val;

// The following are for parse trees.

#define sMIN 0
#define sPROG 1
#define sMAINC 2
#define sCDCLS 3
#define sCDCL 4
#define sVDCLS 5
#define sVDCL 6
#define sMDCLS 7
#define sMDCL 8
#define sSTMTS 9
#define sBSTMT 10
#define sIF 11
#define sWHILE 12
#define sPRINT 13
#define sASSIGN 14
#define sARRASS 15
#define sRETURN 16
#define sMAX 17

#define eMIN 0
#define eADD 1
#define eMINUS 2
#define eTIMES 3
#define eAND 4
#define eOR 5
#define eLT 6
#define eLE 7
#define eEQ 8
#define eARRELE 9
#define eFCALL 10
#define ePAREN 11
#define eDOTOBJ 12
#define eLIT 13
#define eID 14
#define eTHIS 15
#define eNEWARR 16
#define eNEW 17
#define eEXPS 18
#define eEREST 19
#define eFORMALS 20
#define eFREST 21
#define tINTARR 22
#define tINT 23
#define tID 24
#define eMAX 25

typedef struct j_exp {
  int exp_id;
  char name[16];
  int  val;
  struct j_exp *exp1;
  struct j_exp *exp2;
  struct j_exp *next;
} jEXP;

typedef struct j_stm {
  int stm_id;
  struct j_exp *exp1;
  struct j_exp *exp2;
  struct j_stm *stm1;
  struct j_stm *stm2;
  struct j_stm *stm3;
} jSTM;

extern jEXP* create_exp();
extern jSTM* create_stm();
extern void free_exp( jEXP* );
extern void free_stm( jSTM* );
extern void print_exp( jEXP* );
extern void print_stm( jSTM* );
extern jSTM* program;


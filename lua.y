%{
#ifdef _MSC_VER	   //   
			
  #define _CRT_SECURE_NO_WARNINGS
    #include <conio.h>

#else
#endif
#include <stdio.h>

#include <stdlib.h>

int whileUnits=0;
int forUnits=0;
int repeatUnits=0;
int ifUnits=0;
int functionCalls=0;
int localVars=0;
int doUnits=0;
int functionCount=0;
int localFunctions=0;

extern int comments;
extern int lines;



void yyerror(const char *s)
{
	printf("At %d ",lines);
	printf("%s",s);
	exit(1);
}

int yylex(void);
extern FILE* yyin;




%}


%token DO WHILE FOR UNTIL REPEAT END IN IF THEN ELSEIF ELSE GOTO LOCAL BREAK NIL FALSE TRUE NUMBER TDOT FUNCTION RETURN NAME LABEL PLUS MINUS STRING TIMES DIVIDE POWER MODULO EQUALS LESS_THAN MORE_THAN LESS_EQUAL_THAN MORE_EQUAL_THAN TILDE_EQUAL AND OR SQUARE NOT APPEND ASSIGN DOT COLON COMMA SEMICOLON BRACES_L BRACES_R BRACKET_L BRACKET_R PARANTHESES_L PARANTHESES_R MYEOF TILDE PIPE AMPERSAND LEFT_SHIFT RIGHT_SHIFT

%left MINUS OR PLUS NOT TIMES DIVIDE POWER MODULO EQUALS LESS_THAN MORE_THAN LESS_EQUAL_THAN MORE_EQUAL_THAN TILDE_EQUAL AND SQUARE APPEND TILDE PIPE AMPERSAND LEFT_SHIFT RIGHT_SHIFT 

%%

unit : piece_code {printf("unit is here\n");}
;

piece_code : futher_piece_code last_piece_code {printf("piece_code is here\n");}
| futher_piece_code {printf("piece_code is here\n");}
| last_piece_code {printf("piece_code is here\n");}
;

futher_piece_code: instruction {printf("futher_piece_code is here\n");}
| piece_code instruction {printf("futher_piece_code is here\n");}
;




last_piece_code: RETURN datagroup {printf("last_piece_code is here\n");}
| RETURN {printf("last_piece_code is here\n");}
| BREAK {printf("last_piece_code is here\n");}
;




instruction	: seqgroup ASSIGN datagroup {printf("instruction is here\n");}
| LOCAL namegroup ASSIGN datagroup {printf("instruction is here\n");localVars++;}
| LOCAL namegroup {printf("instruction is here\n");localVars++;}
| FUNCTION name_routine structure_routine {printf("instruction is here\n");functionCount++;}
| LOCAL FUNCTION NAME structure_routine {printf("instruction is here\n");functionCount++;localFunctions++;}
| jmp_routine {printf("instruction is here\n");functionCalls++;}
| DO unit END {printf("instruction is here\n");doUnits++;}
| DO END {printf("instruction is here\n");doUnits++;}
| whileunit {printf("instruction is here\n");whileUnits++;}
| REPEAT unit UNTIL data {printf("instruction is here\n");repeatUnits++;}
| REPEAT UNTIL data {printf("instruction is here\n");repeatUnits++;}
| ifunit {printf("instruction is here\n");ifUnits++;}
| forunit {printf("instruction is here\n");forUnits++;}
| GOTO NAME {printf("instruction is here\n");}
| LABEL {printf("instruction is here\n");}
| SEMICOLON
| MYEOF {return 0;}
;

forunit: FOR NAME ASSIGN data COMMA data DO unit END {printf("forunit is here\n");}
| FOR NAME ASSIGN data COMMA data COMMA data DO unit END {printf("forunit is here\n");}
| FOR namegroup IN datagroup DO unit END {printf("forunit is here\n");}
| FOR NAME ASSIGN data COMMA data DO END {printf("forunit is here\n");}
| FOR NAME ASSIGN data COMMA data COMMA data DO END {printf("forunit is here\n");}
| FOR namegroup IN datagroup DO END {printf("forunit is here\n");}
;
		
whileunit: WHILE data DO unit END {printf("whileunit is here\n");}
| WHILE data DO END {printf("whileunit is here\n");}
;

ifunit	: if elseif else END {printf("ifunit is here\n");}
;
		

if: IF data THEN unit {printf("if is here\n");}
| IF data THEN{printf("if is here\n");}
;

elseif: ELSEIF data THEN unit elseif {printf("elseif is here\n");}
| ELSEIF data THEN elseif {printf("elseif is here\n");}
| {printf("elseif is here\n");}
;

else: ELSE unit {printf("else is here\n");}
| ELSE {printf("else is here\n");}
| /* empty */ {printf("else is here\n");}
;

seq: NAME {printf("seq is here\n");}
| frontdata BRACKET_L data BRACKET_R {printf("seq is here\n");}
| frontdata DOT NAME {printf("seq is here\n");}
;

seqgroup: seq {printf("seqgroup is here\n");}
| seqgroup COMMA seq {printf("seqgroup is here\n");}
;

name_routine: next_name_routine {printf("name_routine is here\n");}
| next_name_routine COLON NAME {printf("name_routine is here\n");}
;

next_name_routine: NAME {printf("next_name_routine is here\n");}
| next_name_routine DOT NAME {printf("next_name_routine is here\n");}
;

namegroup: NAME {printf("namegroup is here\n");}
| namegroup COMMA NAME {printf("namegroup is here\n");}
		;

data: NIL {printf("data is here\n");}
| FALSE {printf("data is here\n");}
| TRUE {printf("data is here\n");}
| NUMBER {printf("data is here\n");}
| STRING {printf("data is here\n");}
| TDOT {printf("data is here\n");}
| routine {printf("data is here\n");}
| frontdata {printf("data is here\n");}
| hash_table {printf("data is here\n");}
| data OR data {printf("data is here\n");}
| data AND data {printf("data is here\n");}
| data LESS_THAN data {printf("data is here\n");}
| data LESS_EQUAL_THAN data {printf("data is here\n");}
| data MORE_THAN data {printf("data is here\n");}
| data MORE_EQUAL_THAN data {printf("data is here\n");}
| data TILDE_EQUAL data {printf("data is here\n");}
| data EQUALS data {printf("data is here\n");}
| data APPEND data {printf("data is here\n");}
| data PLUS data {printf("data is here\n");}
| data MINUS data {printf("data is here\n");}
| data TIMES data {printf("data is here\n");}
| data DIVIDE data {printf("data is here\n");}
| data MODULO data {printf("data is here\n");}
| NOT data {printf("data is here\n");}
| SQUARE data {printf("data is here\n");} 
| MINUS data {printf("data is here\n");} 
| data POWER data {printf("data is here\n");} 
| data LEFT_SHIFT data {printf("data is here\n");} 
| data RIGHT_SHIFT data {printf("data is here\n");} 
| data PIPE data {printf("data is here\n");} 
| data AMPERSAND data {printf("data is here\n");}
| data TILDE data {printf("data is here\n");} 
| TILDE data {printf("data is here\n");} 

;

datagroup : data {printf("datagroup is here\n");}
| datagroup COMMA data {printf("datagroup is here\n");}
;

frontdata: seq {printf("frontdata is here\n");}
| jmp_routine {printf("frontdata is here\n");}
| PARANTHESES_L data PARANTHESES_R {printf("frontdata is here\n");}
;


routine: FUNCTION structure_routine {printf("routine is here\n");}
;

jmp_routine: frontdata args {printf("jmp_routine is here\n");}
| frontdata COLON NAME args {printf("jmp_routine is here\n");}
;

structure_routine: PARANTHESES_L parameters PARANTHESES_R unit END {printf("structure_routine is here\n");}
| PARANTHESES_L PARANTHESES_R unit END {printf("structure_routine is here\n");}
| PARANTHESES_L PARANTHESES_R END {printf("structure_routine is here\n");}
| PARANTHESES_L parameters PARANTHESES_R END {printf("structure_routine is here\n");}
;

parameters	: namegroup {printf("parameters is here\n");}
| namegroup COMMA TDOT {printf("parameters is here\n");}
| TDOT {printf("parameters is here\n");}
;

args	: PARANTHESES_L PARANTHESES_R {printf("args is here\n");}
| PARANTHESES_L datagroup PARANTHESES_R {printf("args is here\n");}
| hash_table {printf("args is here\n");}
| STRING {printf("args is here\n");}
;






hash_table: BRACES_L spotgroup BRACES_R {printf("hash_table is here\n");}
| BRACES_L BRACES_R {printf("hash_table is here\n");}
;

spot	: BRACKET_L data BRACKET_R ASSIGN data {printf("spot is here\n");}
| NAME ASSIGN data {printf("spot is here\n");}
| data {printf("spot is here\n");}
;

spotgroup: next_spotgroup nextspot {printf("spotgroup is here\n");}
;

next_spotgroup: spot {printf("next_spotgroup is here\n");}
| next_spotgroup spotdelimiter spot {printf("next_spotgroup is here\n");}

nextspot: spotdelimiter {printf("nextspot is here\n");}
| /* empty */ {printf("nextspot is here\n");}
;

spotdelimiter: COMMA {printf("spotdelimiter is here\n");}
| SEMICOLON {printf("spotdelimiter is here\n");}
;

		
%%

void PrintResults()
{
	printf("\n\n-------------------------------------------------------\n");
	printf("comments : %d\n",comments);
	printf("functions : %d\n",functionCount);
	printf("local functions : %d\n",functionCount);
	printf("functions calls : %d\n",functionCalls);
	printf("local variables : %d\n",localVars);
	printf("if units : %d\n",ifUnits);
	printf("while units : %d\n",whileUnits);
	printf("repeat units : %d\n",repeatUnits);
	printf("for units : %d\n",forUnits);
	printf("do units : %d\n",doUnits);
}

int main(int argc,char *argv[])
	{
		

const char* filename=argv[1];
    FILE* myfile=fopen(filename,"r");
    if(!myfile)
	{
	  printf("Can not open the file\n");
	  return -1;
	} 
    yyin=myfile;
    while(!feof(yyin))
    {
     
	yyparse();

    }
    		PrintResults();
    return 0;





	}

%option noyywrap 
%x LUA_COMMENT 
%{



#ifdef _WIN32
  #include "lua.tab.h"
#else //LINUX
  #include "y.tab.h"
#endif

extern void yyerror(const char *s);
extern int yylex(void);

static void SkipComments();
static void parseBlockString();


#include <stdio.h>
#include <stdlib.h>
int lines = 1;
int comments;
%}

NUMBERS123 [0-9]+|[0-9]+[Ee\.][0-9]*|[0-9]*[Ee\.][0-9]+|[0-9]*[\.][0-9]+[Ee][+-]?[0-9]*|[0-9]+[\.][Ee][+-]?[0-9]*|0x[A-Fa-f0-9]+|0x[A-Fa-f0-9]+"."[A-Fa-f0-9]*


%%

"do" { printf("do: %s\n",yytext); return DO; } 																							   
"while"   { printf("while: %s\n",yytext); return WHILE; }
																									
"for" { printf("for: %s\n",yytext); return FOR; }

"until"   { printf("until: %s\n",yytext); return UNTIL; }
	
"repeat"	{ printf("repeat: %s\n",yytext); return REPEAT;}
	
"end"     {printf("end: %s\n",yytext); return END;}
	
"in" { printf("in: %s\n",yytext); return IN; }

"if"	{ printf("if: %s\n",yytext); return IF;}

"then"	{ printf("then: %s\n",yytext); return THEN;}

"elseif"  { printf("elseif: %s\n",yytext); return ELSEIF; }

"else"	  {printf("else: %s\n",yytext); return ELSE; }
																			
"local"	  {printf("local: %s\n",yytext); return LOCAL; }

"function" {printf("function: %s\n",yytext); return FUNCTION;}
"return" {printf("function: %s\n",yytext); return RETURN;}
	                   
"break"	{printf("break: %s\n",yytext); return BREAK; }
																			
"goto"	{printf("goto: %s\n",yytext); return GOTO;}
																			
[+]    {printf ("operation /+: %s\n",yytext); return PLUS; }

[-]     {printf("operation /-: %s\n",yytext); return MINUS;}

[*]     {printf("operation /*: %s\n",yytext); return TIMES;}

[/]      {printf("operation //: %s\n",yytext); return DIVIDE;}
[/][/]   {printf("operation //: %s\n",yytext); return DIVIDE;}

[\^]     {printf("operation /^: %s\n",yytext); return POWER;}


[%]     {printf("operation /%: %s\n",yytext); return MODULO;}
[~]    { printf("operation /~: %s\n",yytext); return TILDE; }
"|"   { printf("operation /|: %s\n",yytext); return PIPE; }
"&" { printf("operation /&: %s\n",yytext); return AMPERSAND; }
[<][<] { printf("operation /<<: %s\n",yytext); return LEFT_SHIFT; }
[>][>] { printf("operation />>: %s\n",yytext); return RIGHT_SHIFT; }




[=][=]  {printf("operation /==: %s\n",yytext); return EQUALS; }
[<]     { printf("operation /<: %s\n",yytext); return LESS_THAN;}

[<][=]  {printf("operation /<=: %s\n",yytext); return LESS_EQUAL_THAN; }

[>]    {printf("operation />: %s\n",yytext); return MORE_THAN;}

[>][=]   {printf("operation />=: %s\n",yytext); return MORE_EQUAL_THAN;}

[~][=]   {printf("operation /~=: %s\n",yytext); return TILDE_EQUAL; }

[.][.]   {printf("operation /..: %s\n",yytext); return APPEND; }

"and"    { printf("operation and: %s\n",yytext); return AND;}

"or"     {printf("operation or: %s\n",yytext); return OR;}

"#"      {printf("operation #: %s\n",yytext); return SQUARE;}

"not"    {printf("operation not: %s\n",yytext); return NOT; }
						
"nil"	{printf("nil: %s\n",yytext); return NIL;}

"false"  {printf("false: %s\n",yytext); return FALSE; }

"true"	{ printf("true: %s\n",yytext); return TRUE;}
{NUMBERS123} { printf("number: %s\n",yytext); return NUMBER;}


\"([^\\\"]|\\\n|\\.)*\" { printf ("string: %s\n",yytext); return STRING;}
\'([^\\\']|\\\n|\\.)*\' { printf ("string: %s\n",yytext); return STRING;}
\[{2}([^\]]*[\]]?[^\]]+)*\]{2} { printf("string: %s\n",yytext); return STRING;}

\[= { parseBlockString(); printf("string: %s\n",yytext); return STRING;}


\.\.\. {printf("tdot:%s\n",yytext); return TDOT;}

[A-Za-z_][A-Za-z0-9_]* { printf ("name: %s\n",yytext); return NAME; }



::[A-Za-z_][A-Za-z0-9_]*:: { printf ("label: %s\n",yytext); return LABEL; }
<<EOF>>	 {return MYEOF;}

"--\[\[" { BEGIN(LUA_COMMENT); printf("multi string comment: %s\n",yytext); comments++;}
"--\[=".* {BEGIN(LUA_COMMENT); printf("multi string comment: %s\n",yytext); comments++;}
<LUA_COMMENT>"\]\]" {BEGIN(INITIAL);}
<LUA_COMMENT>"=\]" {BEGIN(INITIAL);}
<LUA_COMMENT>. {}
<LUA_COMMENT>\n {lines++;}
"--".*  {  printf("comment: %s\n",yytext); comments++;}
																			
"=" { printf("assign: %s\n",yytext); return ASSIGN; }

"\."	{ printf("dot: %s\n",yytext); return DOT; }

:	{printf("colon: %s\n",yytext); return COLON; }

,	{ printf("comma: %s\n",yytext); return COMMA; }

;	{ printf("semicolon: %s\n",yytext); return SEMICOLON; }

\(  { printf ("parentheses_l: %s\n",yytext); return PARANTHESES_L;}

\)   { printf ("parantheses_r: %s\n",yytext); return PARANTHESES_R; }
 


\{   { printf("braces_l: %s\n",yytext); return BRACES_L;}

\}  { printf ("braces_r: %s\n",yytext); return BRACES_R; }

[\[] { printf("bracket_l: %s\n",yytext); return BRACKET_L; }

[\]] {printf ("bracket_r: %s\n",yytext); return BRACKET_R;}

[ \t]	{ /* spacing */}

[\n]	{ lines++; }

%%
static void parseBlockString()
{
	int c;
	int count=1;
	while((c=input())!='[')
	{
		if (c==-1||c!='=')
		{
			yyerror("unterminated string");
		}
		count++;
	}
	c=input();
	if(c=='\n')
	  lines++;
	while (c != -1)
	{
		if (c==']')
		{
			int temp=count;
			while((c = input()) == '=')
			{
				temp--;
			}
			if (c==']')
			{
				if (temp==0)
					return;
				continue;
			}
			c=input();
			if(c=='\n')
	  		 lines++;

			
		}
		else
		{
			c=input();
			if(c=='\n')
	  		  lines++;
		}
	}
	
	if (c==-1)
	{
		yyerror("unterminated string");
	}
}





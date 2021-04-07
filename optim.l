%{
	#define YYSTYPE char*
	#include "y.tab.h"
    #include <stdio.h>
    extern void yyerror(const char *);
    int line = 1;
%}
%%
[\n]				{line++;}
"||"				{yylval = strdup(yytext);return T_OROR;}
"&&"				{yylval = strdup(yytext);return T_ANDAND;}
"=="				{yylval = strdup(yytext);return T_EQEQ;}
"!="				{yylval = strdup(yytext);return T_NEQ;}
"<="				{yylval = strdup(yytext);return T_LEQ;}
">="				{yylval = strdup(yytext);return T_GEQ;}
"="					{yylval = strdup(yytext);return T_EQ; }
":"					{yylval = strdup(yytext);return(':'); }
"-"					{yylval = strdup(yytext);return('-'); }
"+"					{yylval = strdup(yytext);return('+'); }
"*"					{yylval = strdup(yytext);return('*'); }
"%"					{yylval = strdup(yytext);return('%'); }
"/"					{yylval = strdup(yytext);return('/'); }
"<"					{yylval = strdup(yytext);return('<'); }
">"					{yylval = strdup(yytext);return('>'); }
"["					{yylval = strdup(yytext);return('['); }
"]"					{yylval = strdup(yytext);return(']'); }
"goto"				{yylval = strdup(yytext);return T_GOTO;}
"if"				{yylval = strdup(yytext);return T_IF;}
[0-9]+|[0-9]+.[0-9]+		{yylval = strdup(yytext);return T_NUMBER;}
[a-zA-Z_][a-zA-Z_0-9]*				{yylval = strdup(yytext);return T_ID;}
[  \t\v\f]+				{}
.					{ }
%%

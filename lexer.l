%{
    #ifndef YYSTYPE
    #define YYSTYPE char*
    #endif
    
    #include<string.h>
    #include<stdio.h>
    #include "y.tab.h"
    int line = 0;        
    int comment = 0;
    
%}

alpha [A-Za-z_]
digit [0-9]
%option yylineno

%%

 /* skip over white space */
[ \t\n] {}

 /* keywords */
 /* recognize all keywords and return the correct token */
"while" {return T_while;}
"do" {return T_do;}
"if" {return T_if;}
"else" {return T_else;}
"cout" {return T_cout;}
"cin" {return T_cin;}
"endl" {return T_endl;}
"break" {return T_break;}
"continue" {return T_continue;}
"const" {return T_const;}
"void" {return T_void;}
"#include" {return T_include;}
"return" {return T_return;}
"main" {return T_main;}

 /* class definitions */
"class" {return T_class;}
"private" {return T_private;}
"public" {return T_public;}
"protected" {return T_protected;}

 /* recognize punctuation and single char operators 
 and return the ASCII value as the token */ 
 /* recognize two character operators and return the correct token */

 /* relational operators */
[<, >, ?, =] {return *yytext;}
"<="    {return T_lt_eq;}
">="    {return T_gt_eq;}
"=="    {return T_equal;}
"!="    {return T_not_equal;}

 /* arithmetic operators */
[+, -, *, /, %] {return *yytext;}
"++"    {return T_increment;}
"--"    {return T_decrement;}

 /* bitwise operators */
[^, !, |, &] {return *yytext;}

 /* logical operators */
"||"    	{return T_or;}
"&&"    	{return T_and;}

 /* data types*/
 /* recognize int, double, bool, and string constants, return 
 the correct token and set appropriate field of yylval */
"int" 	{yylval = strdup(yytext);return T_int;}
"float" {yylval = strdup(yytext);return T_float;}
"bool" 	{yylval = strdup(yytext);return T_bool;}
"char" 	{yylval = strdup(yytext);return T_char;}
"String" 	{yylval = strdup(yytext);return T_string;}

 /* recognize identifiers, return the correct 
 token and set appropriate fields of yylval */
{alpha}({alpha}|{digit})*	{
								//printf("T_identifer: %d\n", yylineno);
								if(yyleng < 32 && yyleng > 0)
								{
									yylval = strdup(yytext);
									return T_identifier;
								}
								else
								{
									yylval = strdup(yytext);
									return T_error_identifier;
								}
							}
{alpha}({alpha}|{digit})*"\.h"	{return T_header;}
"using namespace "{alpha}({alpha}|{digit})*";"	{return T_namespace;}
			
 /* constants  --> return values to be checked */				
{digit}+	{return atoi(yytext);}
{digit}+.({digit}+)?([eE][+-]?{digit}+)?	{return atoi(yytext);}

 /* line and column number to be added */


.    {printf("%c\n", *yytext); return yytext[0];}

%%

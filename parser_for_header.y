%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #ifndef YYSTYPE
  #define YYSTYPE char*
  #endif
 
  int yylex();
  void yyerror(char *);
  extern int yylineno;
  extern char *yytext;
%}

%start S
%token T_while T_do T_if T_else T_cout T_cin T_endl T_break T_continue T_const T_void T_include T_return T_main
%token T_class T_private T_public T_protected T_identifier T_error_identifier T_header T_namespace T_using
%token T_int T_float T_bool T_char T_string
%token T_long T_double T_short T_num T_static
%token T_lt_eq T_gt_eq T_equal T_not_equal
%token T_increment T_decrement
%token T_or T_and
 
%left '<' '>'
%left '+' '-' '*' '/' '%'
%left '^' '|' '&'

%%
S	: Header
	| Class
	| /* lambda */
	;
	
Header	: '#' T_include H_files S 
		| T_using T_namespace T_identifier ';' S	
		;

H_files	: '\"' T_header '\"'
		| '<' T_header '>'
		| '\"' T_identifier '\"'
		| '<' T_identifier '>'
		;	

Class	: T_class T_identifier '{' Class_body '}' ';' S
		| T_class T_identifier '{' Class_body '}' Var_list ';' S
		;
		
Class_body	: Access_specifier ':' Class_members Class_body
			|/* lambda */
			;
			
Access_specifier	: T_public | T_private | T_protected ;
			
Class_members	: Datatype T_identifier ';' Class_members
				| /* lambda */
				;
				
Datatype	: T_int | T_float | T_bool | T_char | T_string
			| T_int '*' | T_float '*' | T_char '*'
			;
		
Var_list	:	T_identifier ',' Var_list
			|	T_identifier

%%

int main(int argc,char *argv[])
{
  yyparse();
  return 0;
}


void yyerror(char *s)
{
  printf("Error maa :%s at %d \n",yytext,yylineno);
}


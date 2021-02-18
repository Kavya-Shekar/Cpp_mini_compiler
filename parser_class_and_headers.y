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
%token T_while T_do T_if T_else T_cout T_cin T_endl T_break T_continue T_const T_include T_return T_main
%token T_class T_private T_public T_protected T_identifier T_error_identifier T_header T_namespace T_using
%token T_int T_float T_bool T_char T_string T_void
%token T_long T_double T_short T_num T_static T_virtual T_mutable T_friend
%token T_lt_eq T_gt_eq T_equal T_not_equal
%token T_increment T_decrement
%token T_or T_and
 
%left '<' '>'
%left '+' '-' '*' '/' '%'
%left '^' '|' '&'

%%
S	: Header S
	| Class S
	| Function S
	| Function_decl S
	| /* lambda */
	;
	
Header	: '#' T_include H_files
		| T_using T_namespace T_identifier ';'
		;

H_files	: '\"' T_header '\"'
		| '<' T_header '>'
		| '\"' T_identifier '\"'
		| '<' T_identifier '>'
		;	

Class	: T_class T_identifier Base_class '{' Class_body '}' Var_list ';'
		;

Base_class	: ':' Virtual Access_specifier T_identifier Base_class_list
			|/* lambda */
			;

Base_class_list	: ',' Virtual Access_specifier T_identifier Base_class_list
				| /* lambda */
				;

Virtual	: T_virtual
		| /* lamdba */
		;
		
Class_body	: Access_specifier ':' Class_members Class_body
			|/* lambda */
			;
			
Access_specifier	: T_public | T_private | T_protected ;
			
Class_members	: Datatype T_identifier ';' Class_members
				| T_static Datatype T_identifier ';' Class_members
				| T_mutable Datatype T_identifier ';' Class_members
				| T_const Var_initialize ';' Class_members 
				| T_static T_const Var_initialize ';' Class_members 
				
				| Function_decl Class_members
				| Function Class_members
				| T_static Function_decl Class_members
				| T_static Function Class_members
				| T_virtual Function_decl Class_members
				| T_virtual Function Class_members
				
				| T_friend T_class T_identifier ';' Class_members
				| T_friend Datatype T_identifier '(' ')' ';' Class_members
				| T_friend Datatype T_identifier ':' ':' T_identifier '(' ')' ';' Class_members
				| T_friend Function Class_members
				
				| /* lambda */
				;
				
Var_initialize	: T_int T_identifier '=' T_num
				| /*lambda */
				;

Datatype	: T_int | T_float | T_bool | T_char | T_string | T_void
			| T_int '*' | T_float '*' | T_char '*' | T_void '*'
			;
		
Var_list	: T_identifier ',' Var_list
			| T_identifier
			| /* lambda */
			;

Function_decl	: Datatype T_identifier '(' Parameter ')' ';'
				| Datatype T_identifier '(' ')' ';'
				;
				
Function	: Datatype T_identifier '(' Parameter ')' '{' Func_body '}'
			| Datatype T_identifier '(' ')' '{' Func_body '}'
			| Datatype T_identifier ':' ':' T_identifier '(' Parameter ')' '{' Func_body '}'			
			| Datatype T_identifier ':' ':' T_identifier '(' ')' '{' Func_body '}'
			;
			
Parameter	: Datatype T_identifier Parameter
			| Datatype T_identifier ',' Parameter
			| Datatype T_identifier 
			| Datatype T_identifier '=' T_num Var_initialize /*have to add other initializations too */
			;
			
Func_body 	: Var_initialize ';'
			;
%%

int main(int argc,char *argv[])
{
  yyparse();
  return 0;
}


void yyerror(char *s)
{
  printf("Error maa : %s at %d \n",yytext,yylineno);
}


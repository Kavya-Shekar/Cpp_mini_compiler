%{
	#include <stdio.h>
	#include <string.h>
	#include<stdlib.h>
	void yyerror(const char *);
	#define YYSTYPE char*
	FILE *yyin;
	int yylex();
	extern int line;
	FILE *out;

	typedef struct symbol_table_node
	{
		char name[30];
		char value[30];

	}NODE;

	NODE table[100];
	int top = -1;
	void ModifySymTab(char*,char*);
	char* searchValue(char*);
	char* doOperations(char*,char*,char*);
%}

%token  T_ID T_NUMBER T_GOTO T_IF T_LEQ T_GEQ T_MOD T_EQEQ T_NEQ T_OROR T_ANDAND T_EQ T_IFF


%%
supreme_start
	:start supreme_start
	|start
	;

start
	:T_ID T_EQ T_NUMBER          {
									ModifySymTab($1,$3); fprintf(out,"%s = %s\n",$1,$3);
								 }
	|T_ID T_EQ T_ID              {
										ModifySymTab($1,searchValue($3)); fprintf(out,"%s = %s\n",$1,searchValue($3));
								 }
	|T_ID T_EQ T_ID OPER T_ID   {
									ModifySymTab($1,doOperations($4,searchValue($3),searchValue($5))); fprintf(out,"%s = %s\n",$1,doOperations($4,searchValue($3),searchValue($5)));
							    }
	|T_ID T_EQ T_NUMBER OPER T_ID	{
									    ModifySymTab($1,doOperations($4,$3,searchValue($5))); fprintf(out,"%s = %s\n",$1,doOperations($4,$3,searchValue($5)));
									}
	|T_ID T_EQ T_ID OPER T_NUMBER		{ ModifySymTab($1,doOperations($4,searchValue($3),$5)); 
                                            fprintf(out,"%s = %s\n",$1,doOperations($4,searchValue($3),$5)); 
                                        }
	|T_ID T_EQ T_NUMBER OPER T_NUMBER	{
														ModifySymTab($1,doOperations($4,$3,$5));
														fprintf(out,"%s = %s\n",$1,doOperations($4,$3,$5));
										}
	|T_GOTO T_ID {fprintf(out,"%s %s\n",$1,$2);}
	|T_IF T_ID T_GOTO T_ID {fprintf(out,"%s %s %s %s\n",$1,$2,$3,$4);}
	|T_IFF T_ID T_GOTO T_ID {fprintf(out,"%s %s %s %s\n",$1,$2,$3,$4);}
	|T_ID':' {fprintf(out,"%s:\n",$1);}
	|T_ID T_EQ T_ID '[' T_ID ']' {fprintf(out,"%s %s %s%s%s%s\n",$1,$2,$3,$4,$5,$6);}
	|T_ID '[' T_ID ']' T_EQ T_ID {fprintf(out,"%s%s%s%s %s %s",$1,$2,$3,$4,$5,$6);}
	;

OPER:
	'+'
	|'-'
	|'*'
	|'/'
	|'<'
	|'>'
	|T_LEQ
	|T_GEQ
	|T_MOD
	|T_EQEQ
	|T_NEQ
	|T_OROR
	|T_ANDAND
	;
%%

int main()
{
printf("%s\t%s\n","Name","Value");
out = fopen("Optimised.txt", "w");
if(out==NULL)
{
	printf("ICG not found\n");
}
yyin = fopen("Optim_ICG.txt","r");
if(!yyparse())
{
	printf("Optimised ICG Generated\n");
}

return 1;
}

void yyerror(const char *msg)
{
	printf("Parsing Unsuccesful\n");
}

void ModifySymTab(char* name,char* value)
{
	if(top==-1)
	{

		top++;
		strcpy(table[top].name,name);
		strcpy(table[top].value,value);
		printf("%s\t%s\n",table[top].name,table[top].value);
		return;
	}
	for(int i = top;i>=0;i--)
	{
		if(strcmp(table[i].name,name)==0)
		{
			strcpy(table[i].value,value);
			printf("%s\t%s\n",table[i].name,table[i].value);
			return;
		}
	}

	top++;

	strcpy(table[top].name,name);
	strcpy(table[top].value,value);
    printf("%s\t%s\n",table[top].name,table[top].value);


}
char* searchValue(char* name)
{
	for(int i = top;i>=0;i--)
	{
		if(strcmp(table[i].name,name)==0)
		{
			return table[i].value;
		}
	}
	return "a";
}
char* doOperations(char* opr,char* op1,char* op2)
{
	char* result;
	result = (char*)malloc(sizeof(char)*30);
	int oper1 = atoi(op1); int oper2 = atoi(op2); int res;
	if(strcmp(opr,"+")==0) {res = oper1 + oper2;}
	if(strcmp(opr,"-")==0) {res = oper1 - oper2;}
	if(strcmp(opr,"*")==0) {res = oper1 * oper2;}
	if(strcmp(opr,"/")==0) {res = oper1 / oper2;}
	if(strcmp(opr,">")==0) {res = oper1 > oper2;}
	if(strcmp(opr,"<")==0) {res = oper1 < oper2;}
	if(strcmp(opr,">=")==0) {res = oper1 >= oper2;}
	if(strcmp(opr,"<=")==0) {res = oper1 <= oper2;}
	if(strcmp(opr,"mod")==0) {res = oper1 % oper2;}
	if(strcmp(opr,"==")==0) {res = oper1 == oper2;}
	if(strcmp(opr,"!=")==0) {res = oper1 != oper2;}
	if(strcmp(opr,"&&")==0) {res = oper1 && oper2;}
	if(strcmp(opr,"||")==0) {res = oper1 || oper2;}
	snprintf(result,30*sizeof(char),"%d",res);
	return result;
}

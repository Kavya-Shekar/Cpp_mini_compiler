%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #ifndef YYSTYPE
  # define YYSTYPE char*
  #endif
 
  int yylex();
  void yyerror(char *);
  void lookup(char *,int,char,char*,char* );
  char* get_val(char *);
  void update(char *,int,char *);
  int search_id(char *,int );
  extern FILE *yyin;
  extern int yylineno;
  extern char *yytext;
  typedef struct symbol_table
  {
    int line;
    char name[31];
    char type;
    char *value;
    int scope;
    char *datatype;
  }ST;
  int struct_index = 0;
  ST st[10000];
  char x[10];
%}
%start S
%token T_while T_do T_if T_elseif T_else T_cout T_cin T_endl T_break T_continue T_const T_void T_return T_main T_class T_private T_public T_protected T_static T_include T_namespace T_using
%token T_header T_int T_float T_bool T_char T_string T_long T_double T_short T_STRING
%token T_lt_eq T_gt_eq T_equal T_not_equal T_increment T_decrement T_or T_and
%token T_identifier T_num T_error_identifier



%%
S	
	: HEADER {printf("\nINPUT ACCEPTED.\n");}
	;

HEADER
	: '#' T_include HEADERFILE HEADER
	| T_using T_namespace T_identifier ';' HEADER
	| MAIN
	;

HEADERFILE
	: '\"' T_header '\"'
	| '<' T_header '>'
	| '\"' T_identifier '\"'
	| '<' T_identifier '>'
	;
MAIN
	: T_int T_main '('')' BODY
	| T_void T_main '('')' BODY
	;

BODY
	: '{' C BODY '}'
	|
	;

C
	: DECLR ';' C 
	| STATEMENTS ';' C
	| LOOP C
	|
	;

LOOP
	: T_if '(' COND ')' '{' C '}' IF_L
	| T_do '{' C '}' T_while '(' COND ')' ';'
	;
UX
	: T_identifier UO
	| UO T_identifier
	;

UO 
	: T_increment 
	| T_decrement
	;

IF_L
	: T_elseif '(' COND ')' '{' C '}' IF_L
	| T_else '{' C '}' IF_L
	|
	;



COND
      : LIT RELOP COND
      |'(' COND ')'COND
      | NEG COND
      | LOGIC_OP COND
      |
      ;
RELOP
      : '>'
      | '<' 
      | T_lt_eq 
      | T_gt_eq 
      | T_equal 
      | T_not_equal
      |
      ;

LOGIC_OP
      : T_and 
      | T_or
      | '|'
      | '&'
      ;

NEG
      : '~'
      ;


TYPE
	: T_int
	| T_float
	| T_char
	| T_bool
	| T_string
	| T_long
	| T_double
	| T_short
	;
	

DECLR
	: TYPE DECLR
	| T_static TYPE DECLR
	| T_const DECLR
	| LISTVAR
	;

LISTVAR
	: X
	| LISTVAR ',' X
	;

X
	: T_identifier 
	| ASSIGN
	;
	
ASSIGN
	: T_identifier '=' EXP 
	;

STATEMENTS
	: T_return EXP
	| UX
	| PRINT 
	|
	;	

EXP
	: TERM 
	| EXP '+' TERM
	| EXP '-' TERM
	;
TERM
	: FACTOR
	| TERM '*' FACTOR
	| TERM '/' FACTOR
	;
FACTOR
      : LIT 
      | '(' EXP ')' 
      ;

LIT
      : T_identifier 
      | T_num
      ;
	
PRINT
      : T_cout  OUT 
      | T_cin IN
      ;
IN
      : '>''>' T_PRINT IN
      |
      ;
OUT
      : '<''<' T_PRINT OUT
      |
      ;
T_PRINT
	: T_STRING
	| LIT
	| T_endl
	;
    
%%

int main(int argc,char *argv[])
{
  yyin = fopen("/home/yashashvini/Desktop/CD/p1/input.c","r");
  if(!yyparse())  //yyparse-> 0 if success
  {
  	printf("Parsing Complete\n");
    FILE *fptr;
    fptr = fopen("symbol.txt", "a");
    if(fptr == NULL)
    {
          printf("Error!");
          exit(1);
    }
    else
    {
    fprintf(fptr,"Number of entries in the symbol table = %d\n\n",struct_index);
    fprintf(fptr,"-----------------------------------Symbol Table-----------------------------------\n\n");
    fprintf(fptr,"S.No\t  Token  \t Line Number \t Category \t DataType \t Value \n");
    for(int i = 0;i < struct_index;i++)
    {
      char *ty;
      
      if(st[i].type=='K')
        ty="keyword";
      else if(st[i].type=='I')
      {
        ty="identifier";
        fprintf(fptr,"%-4d\t  %-7s\t   %-10d \t %-9s\t  %-7s\t   %-5s\n",i+1,st[i].name,st[i].line,ty,st[i].datatype,st[i].value);
      }
      else if(st[i].type=='C')
        ty="constant";
      else
        ty="operator";
      if(st[i].type!='I')
        fprintf(fptr,"%-4d\t  %-7s\t   %-10d\t %-9s\t  NULL\t\t %-5s\n",i+1,st[i].name,st[i].line,ty,st[i].value);
    }
    }
    fclose(fptr);
  }
  else
  {
    printf("Parsing failed\n");
  }
  fclose(yyin);
  return 0;
}


void yyerror(char *s)
{
  printf("Error :%s at %d \n",yytext,yylineno);
}
void lookup(char *token,int line,char type,char *value,char *datatype)
{
  //printf("Token %s line number %d\n",token,line);
  int flag = 0;
  for(int i = 0;i < struct_index;i++)
  {
    if(!strcmp(st[i].name,token))
    {
      flag = 1;
      if(st[i].line != line)
      {
        st[i].line = line;
      }
    }
  }
  
  //Insert
  if(flag == 0)
  {
    strcpy(st[struct_index].name,token);
    st[struct_index].type=type;
    if(value==NULL)
        st[struct_index].value=NULL;
    else
        strcpy(st[struct_index].value,value);
        
    if(datatype==NULL)
        st[struct_index].datatype=NULL;
    else
        st[struct_index].datatype=datatype;
        
    st[struct_index].line = line;
    struct_index++;
  }
}
/*
void insert(char *token,int line,char type, char* value, char *datatype)
{
  printf("start");
  strcpy(st[struct_index].name,token);
  st[struct_index].type=type;
  strcpy(st[struct_index].value,value);
  strcpy(st[struct_index].datatype,datatype);
  st[struct_index].line = line;
  struct_index++;
  printf("end");
}
*/
int  search_id(char *token,int lineno)
{
  int flag = 1;
  for(int i = 0;i < struct_index;i++)
  {
    if(!strcmp(st[i].name,token))
    {
      flag = 0;
      return flag;
    }
  }
  return flag;
}

void update(char *token,int lineno,char *value)
{
  int flag = 0;
  
  for(int i = 0;i < struct_index;i++)
  {
    if(!strcmp(st[i].name,token))
    {
      flag = 1;
      st[i].value = (char*)malloc(sizeof(char)*strlen(value));
      //sprintf(st[i].value,"%s",value);
      strcpy(st[i].value,value);
      st[i].line = lineno;
      return;
    }
  }
  if(flag == 0)
  {
    printf("Error at line %d : %s is not defined\n",lineno,token);
    exit(0);
  }
}

char* get_val(char *token)
{
  int flag = 0;
  for(int i = 0;i < struct_index;i++)
  {
    if(!strcmp(st[i].name,token))
    {
      flag = 1;
      return st[i].value;
    }
  }
  if(flag == 0)
  {
    printf("Error at line : %s is not defined\n",token);
    exit(0);
  }
}

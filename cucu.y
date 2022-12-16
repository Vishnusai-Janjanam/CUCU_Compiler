%{
  #include<stdio.h>
  #include<math.h>
  #include<cstring>
  int yylex();
  void yyerror(const char* message);
  // int yydebug =1;
  char current_type[100];
  int ck =1;
  FILE* out_parser =fopen("PARSER.txt","w");
  extern FILE* yyin;
  int cnt=0;
%}
%union{
  int number;
  char * string;
  char character;
}

%token<number> CONST
%token<string> STRING IDENTIFIER  EQ NEQ CHAR
%token<character>  PLUS MINUS MULL DIVIDE
%token INT CHAR_ARR COMMA LEFT_PAREN RIGHT_PAREN LEFT_CURLY RIGHT_CURLY SEMI CHAR_TYPE STRUCT FLOAT
%token IF ELSE WHILE ASSIGN LEFT_SQUARE RIGHT_SQUARE RETURN 
%left EQ NEQ
%left PLUS MINUS
%left MULL DIVIDE
%left LEFT_PAREN RIGHT_PAREN


%%

programs:  programs program | program 
program:    structure |function |data_type var_declare SEMI |data_type func_head {cnt=0; ck=1;} SEMI {fprintf(out_parser, "\n\nEnd of function\n\n");};
data_type: INT      {strcpy(current_type, "int");}
         | CHAR_ARR {strcpy(current_type,"char *");}
         | CHAR_TYPE  {strcpy(current_type,"CHAR");}
         | FLOAT      {strcpy(current_type,"FLOAT");}
structure: STRUCT IDENTIFIER {fprintf(out_parser,"STRUCT NAME %s\n",$2);} LEFT_CURLY struct_var_declare RIGHT_CURLY SEMI
struct_var_declare: struct_var_declare var_dec | var_dec
var_dec: data_type IDENTIFIER SEMI {fprintf(out_parser,"Structure variable: %s, Type: %s\n\n",$2, current_type);}
        | data_type IDENTIFIER LEFT_SQUARE CONST RIGHT_SQUARE SEMI {fprintf(out_parser,"Structure variable: %s, Type: %s Array of size %d\n\n",$2, current_type,$4);}
var_declare: IDENTIFIER {fprintf(out_parser,"Global variable: %s, Type: %s\n\n",$1, current_type);}
            | var_declare COMMA IDENTIFIER  {fprintf(out_parser,"Global variable: %s, Type: %s\n\n",$3,current_type);}
func_head: IDENTIFIER { fprintf(out_parser,"Beginning of function\n"); fprintf(out_parser, "Name of function: %s\n\n",$1);}  LEFT_PAREN args RIGHT_PAREN  
          { 
            fprintf(out_parser,"Total number of arguments: %d\n\n",cnt);
           
          }
args:                       
    {
      
    }
    | data_type IDENTIFIER 
    {
      fprintf(out_parser,"Function Arugment Name: %s, Type: %s\n",$2,current_type);
      cnt++;
    }

    | args COMMA data_type IDENTIFIER 
    
    {
      fprintf(out_parser,"Function Arugment Name: %s, Type: %s\n",$4,current_type);
      cnt++;
    }

function: data_type func_head LEFT_CURLY stmts  RIGHT_CURLY {fprintf(out_parser,"\n\nEnd of function");}

stmts: | stmts func_call  SEMI
      | stmts data_type val_dec_and_assign SEMI
      | stmts assignment SEMI
      | stmts if_stmt 
      | stmts while_stmt 
      | stmts RETURN {fprintf(out_parser,"Returning expression: ");} expr SEMI {fprintf(out_parser,"\n");}
func_call: IDENTIFIER {cnt=0;fprintf(out_parser,"(Calling function %s with arguments ",$1);} LEFT_PAREN seq_identifiers RIGHT_PAREN  {if(cnt==0) fprintf(out_parser,"NONE"); fprintf(out_parser,") ");}
seq_identifiers: | identifier |  seq_identifiers COMMA identifier 
                | func_call {cnt++;}
                | seq_identifiers COMMA func_call {cnt++;} 
identifier: IDENTIFIER {fprintf(out_parser,"var-%s ",$1);cnt++;}
          | CONST {fprintf(out_parser,"const-%d ",$1);cnt++;} 
          | STRING {fprintf(out_parser,"string-%s ",$1);cnt++;}  
          | CHAR  {fprintf(out_parser,"char-%s ",$1);cnt++;}  
val_dec_and_assign: IDENTIFIER index {fprintf(out_parser,"local variable: %s\n",$1);}
                  | val_dec_and_assign COMMA IDENTIFIER index {fprintf(out_parser,"local variable: %s\n",$3);}
                  | assignment

if_stmt: if_block | if_block ELSE {fprintf(out_parser,"\n\nELSE BLOCK BEGIN\n");} LEFT_CURLY stmts RIGHT_CURLY {fprintf(out_parser,"\n\nELSE BLOCK END\n\n");} 
if_block: IF {fprintf(out_parser,"\n\nIF BLOCK BEGIN\n");} LEFT_PAREN {fprintf(out_parser,"boolean expression: ");} bool_expr {fprintf(out_parser,"\n");} RIGHT_PAREN LEFT_CURLY stmts RIGHT_CURLY {fprintf(out_parser,"\n\nIF BLOCK END\n\n");} 

while_stmt: WHILE {fprintf(out_parser,"\n\nWHILE BLOCK BEGIN\n");} LEFT_PAREN {fprintf(out_parser,"boolean expression: ");} bool_expr {fprintf(out_parser,"\n");} RIGHT_PAREN LEFT_CURLY stmts RIGHT_CURLY {fprintf(out_parser,"\n\nWHILE BLOCK END\n");} 

assignment: IDENTIFIER {fprintf(out_parser,"Assignment Begin:\nl-value: %s\n",$1);} index ASSIGN {fprintf(out_parser,"r-value: ");} expr {fprintf(out_parser,"\nAssignment End\n");}
index: | LEFT_SQUARE {fprintf(out_parser,"at index ( "); }expr RIGHT_SQUARE  {fprintf(out_parser,") "); }

bool_expr: expr EQ expr {fprintf(out_parser," %s ",$2); }  
         | expr NEQ expr {fprintf(out_parser,"%s ",$2);}

expr: expr PLUS expr  {fprintf(out_parser,"%c",$2);}
  | expr MINUS expr {fprintf(out_parser,"%c",$2);}
  | expr MULL expr {fprintf(out_parser,"%c",$2);}
  | expr DIVIDE expr {fprintf(out_parser,"%c",$2);}
  | LEFT_PAREN expr RIGHT_PAREN 
  | CONST {fprintf(out_parser,"const-%d ",$1);}
  | IDENTIFIER {fprintf(out_parser,"var-%s ",$1); } index 
  | CHAR {fprintf(out_parser,"char-%s",$1);}
  | func_call
  | bool_expr

%%

int main(int argc, char* argv[]){
  yyin = fopen(argv[1],"r");
  yyparse();
  return 0;
}

void yyerror(const char* message){
  fprintf(out_parser,"\n\nERROR in syntax\n");
}

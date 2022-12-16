%{
  #include<stdio.h>
   #include<math.h>
  #include "cucu.tab.h"
  FILE* out_lexer =fopen("LEXER.txt","w");

  //input left
%}

%%
\/\*([^*]|[\n]|(\*+([^*/]|[\n])))*\*+\/         ;
struct                {fprintf(out_lexer,"TYPE : %s\n",yytext); return STRUCT;}
float                 {fprintf(out_lexer,"TYPE : %s\n",yytext); return FLOAT;}
int                   {fprintf(out_lexer,"TYPE : %s\n",yytext); return INT;}
char[ ]\*             {fprintf(out_lexer,"TYPE : %s\n",yytext); return CHAR_ARR;}
char                  {fprintf(out_lexer,"TYPE : %s\n",yytext); return CHAR_TYPE ;}
\'[^\n]\'             {fprintf(out_lexer,"CHAR : %s\n",yytext); yylval.string=strdup(yytext); return CHAR;}
return                {fprintf(out_lexer,"RETURN : %s\n",yytext); return RETURN;}
if                    {fprintf(out_lexer,"IF : %s\n",yytext); return IF;}
else                  {fprintf(out_lexer,"ELSE : %s\n",yytext); return ELSE;}
while                 {fprintf(out_lexer,"WHILE : %s\n",yytext); return WHILE;} 
,                     {fprintf(out_lexer,"COMMA : %s\n",yytext); return COMMA;}
[a-zA-Z][a-zA-Z0-9_]* {fprintf(out_lexer,"IDENTIFIER : %s\n",yytext);yylval.string=strdup(yytext); return IDENTIFIER;}
[0-9]*                {fprintf(out_lexer,"NUM: %s\n",yytext); yylval.number = atoi(yytext); return CONST;}
\(                    {fprintf(out_lexer,"LEFT_PAREN : %s\n",yytext); return LEFT_PAREN;}
\[                    {fprintf(out_lexer,"LEFT_SQUARE : %s\n",yytext); return LEFT_SQUARE;}
\]                    {fprintf(out_lexer,"RIGHT_SQUARE : %s\n",yytext); return RIGHT_SQUARE;}
\)                    {fprintf(out_lexer,"RIGHT_PAREN : %s\n",yytext); return RIGHT_PAREN;}
\{                    {fprintf(out_lexer,"LEFT_CURLY : %s\n",yytext); return LEFT_CURLY;}
\}                    {fprintf(out_lexer,"RIGHT_CURLY : %s\n",yytext); return RIGHT_CURLY;}
\"[^\n]*\"            {fprintf(out_lexer,"STRING : %s\n",yytext);   yylval.string = strdup(yytext); return STRING;}
;                     {fprintf(out_lexer,"SEMI : %s\n",yytext); return SEMI;}
=                     {fprintf(out_lexer,"ASSIGN : %s\n",yytext); return ASSIGN;}
\+                    {fprintf(out_lexer,"PLUS : %s\n",yytext); yylval.character= yytext[0]; return PLUS;}
-                     {fprintf(out_lexer,"MINUS : %s\n",yytext);yylval.character= yytext[0]; return MINUS;}
\*                    {fprintf(out_lexer,"MULL : %s\n",yytext); yylval.character= yytext[0]; return MULL;}
\/                    {fprintf(out_lexer,"DIVIDE : %s\n",yytext); yylval.character= yytext[0]; return DIVIDE;}
==                    {fprintf(out_lexer,"EQ : %s\n",yytext); yylval.string = strdup(yytext); return EQ;} 
!=                    {fprintf(out_lexer,"NEQ : %s\n",yytext); yylval.string = strdup(yytext); return NEQ;}
[ \t\n]*              ;
.                     {fprintf(out_lexer,"Unidentifier symbol %s found\n",yytext);return 0;}
%%
int yywrap(){return(1);} 

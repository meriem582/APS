
%{
  open Ast
%}

%token LBRA RBRA LPAR RPAR SEMCOL COL COMA ARROW STAR
%token CONST FUN REC ECHO IF AND OR BOOL INT SET VAR WHILE PROC CALL VOID IFSTAT
%token <int> NUM
%token <string> IDENT


%type <Ast.block> prog
%type <Ast.block> block
%type <Ast.cmds> cmds
%type <Ast.def> def
%type <Ast.typ> typ
%type <Ast.typ list> types
%type <Ast.arg> arg
%type <Ast.arg list> args
%type <Ast.stat> stat
%type <Ast.expr> expr
%type <Ast.expr list> exprs

%start prog

%%
prog:
  | block  { $1 }
;

block:
  | LBRA cmds RBRA { ASTBlock($2) }
;

cmds:
  | stat { ASTStat($1) }
  | def SEMCOL cmds { ASTDef($1, $3) }
  | stat SEMCOL cmds { ASTStatCMDS($1, $3) }
;

def:
  | CONST IDENT typ expr { ASTConst($2, $3, $4) }
  | FUN IDENT typ LBRA args RBRA expr { ASTFun($2, $3, $5, $7) }
  | FUN REC IDENT typ LBRA args RBRA expr { ASTFunRec($3, $4, $6, $8) }
  | VAR IDENT typ { ASTVar($2, $3) }
  | PROC IDENT LBRA args RBRA block { ASTProc($2, $4, $6) }
  | PROC REC IDENT LBRA args RBRA block { ASTProcRec($3, $5, $7) }
;

typ:
  | INT { BaseType TInt }
  | BOOL { BaseType TBool }
  | VOID { BaseType TVoid }
  | LPAR types ARROW typ RPAR { ASTArrow($2, $4) }
  
;

types:
  | typ { [$1] }
  | typ STAR types { $1 :: $3 }
;

arg:
  | IDENT COL typ { Arg($1, $3) }
;

args:
  | arg { [$1] }
  | arg COMA args { $1 :: $3 }
;

stat:
  | ECHO expr { ASTEcho($2) }
  | SET IDENT expr { ASTSet($2, $3) }
  | IFSTAT expr block block { ASTIfStat($2, $3, $4) }
  | WHILE expr block { ASTWhile($2, $3) }
  | CALL IDENT exprs { ASTCall($2, $3) }
;

expr:
  | NUM { ASTNum($1) }
  | IDENT { ASTId($1) }
  | LPAR IF expr expr expr RPAR { ASTIf($3, $4, $5) }
  | LPAR AND expr expr RPAR { ASTAnd($3, $4) }
  | LPAR OR expr expr RPAR { ASTOr($3, $4) }
  | LPAR expr exprs RPAR { ASTApp($2, $3) }
  | LBRA args RBRA expr { ASTLambda($2, $4) }
;

exprs:
  | expr { [$1] }
  | expr exprs { $1 :: $2 }
;
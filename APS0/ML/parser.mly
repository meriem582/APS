
%{
  open Ast
%}

%token LBRA RBRA LPAR RPAR SEMCOL COL COMA ARROW STAR
%token CONST FUN REC ECHO IF AND OR BOOL INT
%token <int> NUM
%token <string> IDENT



%type <Ast.cmds> prog
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
  | LBRA cmds RBRA { $2 }
;

cmds:
  | stat { ASTStat($1) }
  | def SEMCOL cmds { ASTDef($1, $3) }


;

def:
  | CONST IDENT typ expr { ASTConst($2, $3, $4) }
  | FUN IDENT typ LBRA args RBRA expr { ASTFun($2, $3, $5, $7) }
  | FUN REC IDENT typ LBRA args RBRA expr { ASTFunRec($3, $4, $6, $8) }
;

typ:
  | INT { BaseType TInt }
  | BOOL { BaseType TBool }
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
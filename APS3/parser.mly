
%{
  open Ast
%}

%token LBRA RBRA LPAR RPAR SEMCOL COL COMA ARROW STAR RETURN
%token CONST FUN REC ECHO IF AND OR BOOL INT SET VAR VARA ADR WHILE PROC CALL VOID IFSTAT VEC ALLOC NTH LEN VSET
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
%type <Ast.exprProc> exprProc
%type <Ast.exprProc list> exprsProc

%start prog

%%
prog:
  | block  { $1 }
;

block:
  | LBRA cmds RBRA { ASTBlock($2) }
;

cmds:
  | return { ASTRetCMDS($1) }
  | stat { ASTStat($1) }
  | def SEMCOL cmds { ASTDef($1, $3) }
  | stat SEMCOL cmds { ASTStatCMDS($1, $3) }
;

return :
  | RETURN expr {ASTRet($2)}
;
def:
  | CONST IDENT typ expr { ASTConst($2, $3, $4) }
  | FUN IDENT typ LBRA args RBRA expr { ASTFun($2, $3, $5, $7) }
  | FUN REC IDENT typ LBRA args RBRA expr { ASTFunRec($3, $4, $6, $8) }
  | VAR IDENT typ { ASTVar($2, $3) }
  | PROC IDENT LBRA argsProc RBRA block { ASTProc($2, $4, $6) }
  | PROC REC IDENT LBRA argsProc RBRA block { ASTProcRec($3, $5, $7) }
  | FUN IDENT typ LBRA argsProc RBRA block { ASTFunDec($2, $3, $5, $7) }
  | FUN REC IDENT typ LBRA argsProc RBRA block { ASTFunRecDec($3, $4, $6, $8) }
;

typ:
  | INT { BaseType TInt }
  | BOOL { BaseType TBool }
  | VOID { BaseType TVoid }
  | LPAR VEC typ RPAR { ASTVec($3) }
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
  | SET lval expr { ASTSet($2, $3) }
  | IFSTAT expr block block { ASTIfStat($2, $3, $4) }
  | WHILE expr block { ASTWhile($2, $3) }
  | CALL IDENT exprsProc { ASTCall($2, $3) }
;

lval:
  | IDENT { ASTLvalIdent($1) }
  | LPAR NTH lval expr RPAR { ASTLvalNth($3, $4) }
;
argProc:
  | IDENT COL typ { ASTArgProc($1, $3) }
  | VARA IDENT COL typ {ASTArgProcVar($2, $4)}
;

argsProc:
  | argProc { [$1] }
  | argProc COMA argsProc { $1 :: $3 }
;

exprProc:
  | expr {ASTExpr($1)}
  | LPAR ADR lval RPAR { ASTExprProc($3) }
;

exprsProc:
  | exprProc { [$1] }
  | exprProc exprsProc { $1 :: $2 }
;
expr:
  | NUM { ASTNum($1) }
  | IDENT { ASTId($1) }
  | LPAR IF expr expr expr RPAR { ASTIf($3, $4, $5) }
  | LPAR AND expr expr RPAR { ASTAnd($3, $4) }
  | LPAR OR expr expr RPAR { ASTOr($3, $4) }
  | LPAR expr exprsProc RPAR { ASTApp($2, $3) }
  | LBRA args RBRA expr { ASTLambda($2, $4) }
  | LPAR ALLOC expr RPAR { ASTAlloc($3) }
  | LPAR LEN expr RPAR { ASTLen($3) }
  | LPAR VSET expr expr expr RPAR { ASTVset($3, $4, $5) }
  | LPAR NTH expr expr RPAR { ASTNth($3, $4) }
;

exprs:
  | expr { [$1] }
  | expr exprs { $1 :: $2 }
;
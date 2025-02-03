%{
(* ========================================================================== *)
(* == UPMC/master/info/4I506 -- Janvier 2016/2017                          == *)
(* == SU/FSI/master/info/MU4IN503 -- Janvier 2020/2021/2022                == *)
(* == Analyse des programmes et sémantiques                                == *)
(* ========================================================================== *)
(* == hello-APS Syntaxe ML                                                 == *)
(* == Fichier: parser.mly                                                  == *)
(* == Analyse syntaxique                                                   == *)
(* ========================================================================== *)

open Ast

%}
  
%token <int> NUM
%token <string> IDENT
%token LBRA, RBRA, LPAR, RPAR, ECHO, CONST, FUN, REC, IF, AND, OR, BOOL, INT, SEMICOLON, COLON, COMMA, ARROW, STAR
%type <Ast.expr> expr
%type <Ast.exprs> exprs
%type <Ast.cmds> cmds
%type <Ast.cmds> prog
%type <Ast.stat> stat
%type <Ast.def> def
%type <Ast.typ> typ
%type <Ast.typs> typs
%type <Ast.arg> arg
%type <Ast.args> args


%start prog

%%
prog: LBRA cmds RBRA    { $2 }
;

cmds:
  stat                  { ASTStat $1 }  
  | def SEMICOLON cmds  { ASTdef ($1, $3) }
  //| stat SEMICOLON  cmds            { ASTStatdebut($1,$3) }
;

stat:
  ECHO expr             { ASTEcho($2) }
;

def:
  CONST IDENT typ expr { ASTConst($2,$3,$4) }
  | FUN IDENT typ LBRA args RBRA expr { ASTFun($2,$3,$5,$7) }
  | FUN REC IDENT typ LBRA args RBRA expr { ASTRec($3,$4,$6,$8) }
;

typ:
  | BOOL                  { Bool }
  | INT                 { Int }
  | LPAR typs ARROW typ RPAR { ASTArrow($2,$4) }
;

typs:
  typ                   { ASTTyp($1) }
  | typ STAR typs            { ASTTyps($1,$3) }
;

arg:
  IDENT COLON typ       { ASTArg($1,$3) }
;

args:
  arg                   { ASTSingleArg($1) } 
  | arg COMMA args      { ASTArgs($1,$3) }



expr:
  NUM                   { ASTNum($1) }
| IDENT                 { ASTId($1) }
| LPAR IF expr expr expr RPAR { ASTIf($3, $4, $5) }
| LPAR AND expr expr RPAR { ASTAnd($3, $4) }
| LPAR OR expr expr RPAR { ASTOr($3, $4) }
| LPAR expr exprs RPAR  { ASTApp($2, $3) } 
| LBRA args RBRA expr  { ASTLambda($2, $4) } 
;

exprs:
  expr                   { ASTExpr($1) }  
| expr exprs             { ASTExprs($1, $2) }  



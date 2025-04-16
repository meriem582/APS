(* ========================================================================== *)
(* == UPMC/master/info/4I506 -- Janvier 2016/2017/2018                     == *)
(* == SU/FSI/master/info/MU4IN503 -- Janvier 2020/2021/2022                == *)
(* == Analyse des programmes et sémantiques                                == *)
(* ========================================================================== *)
(* == hello-APS Syntaxe ML                                                 == *)
(* == Fichier: ast.ml                                                      == *)
(* ==  Arbre de syntaxe abstraite                                          == *)
(* ========================================================================== *)




(* Types de base *)
type base_type = TInt | TBool | TVoid

type typ =
  | BaseType of base_type
  | ASTArrow of typ list * typ
  (*Rajouter pour APS2*)
  | ASTVec of typ

type arg = Arg of string * typ

type argProc =
  | ASTArgProc of string * typ
  | ASTArgProcVar of string * typ


type expr =
  | ASTNum of int
  | ASTId of string
  | ASTIf of expr * expr * expr
  | ASTAnd of expr * expr
  | ASTOr of expr * expr
  | ASTApp of expr * expr list
  | ASTLambda of arg list * expr
  (*Rajouter pour APS2*)
  | ASTAlloc of expr
  | ASTLen of expr
  | ASTNth of expr * expr
  | ASTVset of expr * expr * expr

type exprProc =
  | ASTExpr of expr
  | ASTExprProc of string

type stat = 
  | ASTEcho of expr
  (*Rajouter pour APS2*)
  | ASTSet of lval * expr
  | ASTIfStat of expr * block * block
  | ASTWhile of expr * block
  | ASTCall of string * exprProc list

(*Rajouter pour APS2*)
and lval =
  | ASTLvalIdent of string
  | ASTLvalNth of lval * expr

and def =
  | ASTConst of string * typ * expr
  | ASTFun of string * typ * arg list * expr
  | ASTFunRec of string * typ * arg list * expr
  | ASTVar of string * typ
  | ASTProc of string * argProc list * block
  | ASTProcRec of string * argProc list * block 

and cmds =
  | ASTStat of stat
  | ASTDef of def * cmds
  | ASTStatCMDS of stat * cmds

and block = 
  |ASTBlock of cmds
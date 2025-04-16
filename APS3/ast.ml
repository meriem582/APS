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
  | ASTApp of expr * exprProc list
  | ASTLambda of arg list * expr
  | ASTAlloc of expr
  | ASTLen of expr
  | ASTNth of expr * expr
  | ASTVset of expr * expr * expr

and exprProc =
  | ASTExpr of expr
  | ASTExprProc of lval

and stat = 
  | ASTEcho of expr
  | ASTSet of lval * expr
  | ASTIfStat of expr * block * block
  | ASTWhile of expr * block
  | ASTCall of string * exprProc list

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
  (*Rajouter pour APS3*)
  | ASTFunDec of string * typ * argProc list * block
  | ASTFunRecDec of string * typ * argProc list * block

and cmds =
  (*Rajouter pour APS3*)
  | ASTRetCMDS of ret
  | ASTStat of stat
  | ASTDef of def * cmds
  | ASTStatCMDS of stat * cmds

(*Rajouter pour APS3*)
and ret = 
  | ASTRet of expr

and block = 
  |ASTBlock of cmds
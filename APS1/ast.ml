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
type base_type = TInt 
  | TBool 
(*Rajouter pour APS1*)
  | TVoid

type typ =
  | BaseType of base_type
  | ASTArrow of typ list * typ

type arg = Arg of string * typ

type expr =
  | ASTNum of int
  | ASTId of string
  | ASTIf of expr * expr * expr
  | ASTAnd of expr * expr
  | ASTOr of expr * expr
  | ASTApp of expr * expr list
  | ASTLambda of arg list * expr

type stat = 
  | ASTEcho of expr
  (*Rajouter pour APS1*)
  | ASTSet of string * expr
  | ASTIfStat of expr * block * block
  | ASTWhile of expr * block
  | ASTCall of string * expr list

and def =
  | ASTConst of string * typ * expr
  | ASTFun of string * typ * arg list * expr
  | ASTFunRec of string * typ * arg list * expr
  (*Rajouter pour APS1*)
  | ASTVar of string * typ
  | ASTProc of string * arg list * block
  | ASTProcRec of string * arg list * block 

and cmds =
  | ASTStat of stat
  | ASTDef of def * cmds
  (*Rajouter pour APS1*)
  | ASTStatCMDS of stat * cmds

(*Rajouter pour APS1*)
and block = 
  |ASTBlock of cmds
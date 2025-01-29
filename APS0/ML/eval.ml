open Ast

let environnement = (module Map.Make(String) : Map.S with type key = string)

let symb_prim prim = 
  match prim with
  | ASTId "add" -> true
  | ASTId "sub" -> true
  | ASTId "mul" -> true
  | ASTId "div" -> true
  | ASTId "lt" -> true
  | ASTId "eq" -> true
  | ASTId "not" -> true
  | ASTId "true" -> true
  | ASTId "false" -> true
  | _ -> false



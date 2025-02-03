open Ast

module Env = Map.Make(String)

(*type pour les valeurs qu'on manipule*)

type valeur =
  | VInt of int
  | VBool of bool
  | VFun of args * expr * valeur Env.t  (* Environnement pour les arguments *)
  | VFunRec of string * args * expr * valeur Env.t  (* Gestion de la récursivité *)

type env = valeur Env.t

(* gestion des primitives *)

let is_primitive prim =
    match prim with
    | "add" | "sub" | "mul" | "div" | "lt" | "eq" | "not" | "true" | "false" -> true
    | _ -> false

let eval_prim prim args =
    match prim, args with
    | "add", [VInt x; VInt y] -> VInt (x + y)
    | "sub", [VInt x; VInt y] -> VInt (x - y)
    | "mul", [VInt x; VInt y] -> VInt (x * y)
    | "div", [VInt x; VInt y] when y <> 0 -> VInt (x / y)
    | "lt", [VInt x; VInt y] -> VBool (x < y)
    | "eq", [VInt x; VInt y] -> VBool (x = y)
    | "not", [VBool b] -> VBool (not b)
    | "true", [] -> VBool true 
    | "false", [] -> VBool false
    | _ -> failwith "erreur d'evaluation de la primitive"

(* evaluation des expressions *)

let extract_argument_name (arg : Ast.arg) : string =
  match arg with
  | ASTArg (name, _) -> name


let rec convert_args_to_list (args : Ast.args) : string list =
  match args with
  | ASTSingleArg (ASTArg (id, _)) -> [id]  (* Cas où il n'y a qu'un seul argument *)
  | ASTArgs (ASTArg (id, _), rest) -> id :: convert_args_to_list rest  (* Liste des arguments *)


let rec exprs_to_list (es : Ast.exprs) : Ast.expr list =
  match es with
  | ASTExpr e -> [e]
  | ASTExprs (e, rest) -> e :: exprs_to_list rest


let rec convert_args_to_arg_list (args : Ast.args) : Ast.arg list =
  match args with
  | ASTSingleArg arg -> [arg]  (* Cas où il n'y a qu'un seul argument *)
  | ASTArgs (arg, rest) -> arg :: convert_args_to_arg_list rest  (* Conversion en liste *)
  

let rec eval_expr (e : Ast.expr) (env : env) : valeur =
    match e with
    | ASTNum n -> VInt n
    | ASTId id -> 
      if is_primitive id then eval_prim id []
      else Env.find id env
    | ASTIf (c, t, e) ->
        (match eval_expr c env with 
        | VBool true -> eval_expr t env  (*si la condition est vrai, on evalue la branche t*)
        | VBool false -> eval_expr e env (*si la condition est faux, on evalue la branche e*)
        | _ -> failwith "Condition d'un if doit être un booléen")

    | ASTAnd (e1, e2) ->
        (match eval_expr e1 env, eval_expr e2 env with
        | VBool b1, VBool b2 -> VBool (b1 && b2)
        | _ -> failwith "Les arguments de 'and' doivent être des booléens")

    | ASTOr (e1, e2) ->
        (match eval_expr e1 env, eval_expr e2 env with
        | VBool b1, VBool b2 -> VBool (b1 || b2)
        | _ -> failwith "Les arguments de 'or' doivent être des booléens")

    | ASTLambda (params, body) -> 
      VFun (params, body, env)
    | ASTApp (f, args) ->
      let args_values = List.map (fun arg -> eval_expr arg env) (exprs_to_list args) in
      match f with
      | ASTId id when is_primitive id -> eval_prim id args_values
      | _ ->  
        let func_value = eval_expr f env in     
        (* Nouvelle version de eval_args *)
        let rec eval_args args_list params_list env' =
            match args_list, params_list with
            | [], [] -> env' (* Cas où tous les arguments ont été traités *)
            | arg :: rest_args, ASTArg (id, _) :: rest_params ->
                let v = eval_expr arg env in
                eval_args rest_args rest_params (Env.add id v env')
            | _ -> failwith "Nombre d'arguments incorrect pour la fonction"
          in
          match func_value with
          | VFun (params, e, env') ->
            let new_env = eval_args (exprs_to_list args) (convert_args_to_arg_list params) env' in
            eval_expr e new_env
          | VFunRec (id, params, e, env') ->
            let new_env = eval_args (exprs_to_list args) (convert_args_to_arg_list params) (Env.add id func_value env') in
            eval_expr e new_env
          | _ -> failwith "L'expression à appliquer doit être une fonction"

    
(*evaluation d'une instruction*)

let eval_stat s env output =
  match s with
  | ASTEcho e ->
      let v = eval_expr e env in
      match v with
      | VInt n -> n :: output  (* Ajout en tête pour éviter*)
      | VBool b -> (if b then 1 else 0) :: output
      | _ -> failwith "Echo ne peut afficher que des entiers ou des booléens"


(*evaluation d'une definition*)

let eval_def d env =
    match d with
    | ASTConst (id, _, e) -> 
        let v = eval_expr e env in
        Env.add id v env
    | ASTFun (id, _, params, e) -> 
      let param_names = convert_args_to_arg_list params in
        let v = VFun (param_names, e, env) in
        Env.add id v env
    | ASTRec (id, _, params, e) -> 
      let param_names = convert_args_to_arg_list params in
      Env.add id (VFunRec (id, param_names, e, env)) env

(*evaluation des commandes d'un programme*)

let rec eval_cmds env cmds output =
  match cmds with
  | [] -> output  (* Cas de base *)
  | ASTStat stat :: rest_cmds ->
      let new_output = eval_stat stat env output in
      eval_cmds env rest_cmds new_output
  | ASTdef (def, rest_cmds) :: rest ->
      let new_env = eval_def env def in
      eval_cmds new_env rest_cmds output


(*evaluation du point d'entrée d'un programme*)

let eval_prog p =
    let env = Env.empty in
    let output = eval_cmds env p [] in
    List.iter (fun n -> Printf.printf "%d\n" n) (List.rev output)


(*lecture d'un programme depuis un fichier*)

let _ =
	try
		let fl = open_in Sys.argv.(1) in
		let lexbuf = Lexing.from_channel fl in
		let p = Parser.prog Lexer.token lexbuf in
			(eval_prog p)
	with Lexer.Eof -> exit 0



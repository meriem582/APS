open Ast

module Env = Map.Make(String)

(* Type pour les valeurs manipulées *)
type valeur =
  | VInt of int
  | VBool of bool
  | VClosure of arg list * expr * valeur Env.t  (* Fermeture pour les fonctions *)
  | VRecClosure of string * arg list * expr * valeur Env.t  (* Fonction récursive *)

type env = valeur Env.t

type sortie = valeur list

let est_primitive prim = 
    match prim with
    | ASTId("not") -> true
    | ASTId("add") -> true
    | ASTId("mul") -> true
    | ASTId("sub") -> true
    | ASTId("div") -> true
    | ASTId("eq") -> true
    | ASTId("lt") -> true
    | ASTId("true") -> true
    | ASTId("false") -> true
    | _ -> false

(* Évaluer les primitives *)
let eval_primitive prim args =
  match prim, args with
  | ASTId("add"), [VInt x; VInt y] -> VInt (x + y)
  | ASTId("sub"), [VInt x; VInt y] -> VInt (x - y)
  | ASTId("mul"), [VInt x; VInt y] -> VInt (x * y)
  | ASTId("div"), [VInt x; VInt y] when y <> 0 -> VInt (x / y)
  | ASTId("lt"), [VInt x; VInt y] -> VBool (x < y)
  | ASTId("eq"), [VInt x; VInt y] -> VBool (x = y)
  | ASTId("not"), [VBool b] -> VBool (not b)
  | ASTId("true"), [] -> VBool true 
  | ASTId("false"), [] -> VBool false
  | _ -> failwith "Erreur d'évaluation de la primitive"

(* Évaluation des expressions *)
let rec eval_expr (env: env) (e: expr) : valeur =
  match e with
  | ASTNum n -> VInt n

  | ASTId x -> (try Env.find x env with Not_found -> failwith ("Variable inconnue: " ^ x))

  | ASTIf (cond, e1, e2) -> (
      match eval_expr env cond with
      | VBool true -> eval_expr env e1
      | VBool false -> eval_expr env e2
      | _ -> failwith "Condition non booléenne"
    )

  | ASTAnd (e1, e2) -> (
      match eval_expr env e1, eval_expr env e2 with
      | VBool b1, VBool b2 -> VBool (b1 && b2)
      | _ -> failwith "Opérateurs and doivent être booléens"
    )

  | ASTOr (e1, e2) -> (
      match eval_expr env e1, eval_expr env e2 with
      | VBool b1, VBool b2 -> VBool (b1 || b2)
      | _ -> failwith "Opérateurs or doivent être booléens"
    )

  | ASTLambda (params, body) -> VClosure (params, body, env)

  | ASTApp (func, args) -> 
    let args_values = List.map (fun arg -> eval_expr env arg) args in
    if est_primitive func then eval_primitive func args_values
    else 
      let func_value = eval_expr env func in 
      match func_value with
      | VClosure (params, body, closure_env) ->
        let new_env = List.fold_left2 (fun acc (Arg (x, _)) v -> Env.add x v acc) closure_env params args_values in
        eval_expr new_env body
      | VRecClosure (name, params, body, closure_env) ->
        let rec_env = Env.add name (VRecClosure (name, params, body, closure_env)) closure_env in
        let new_env = List.fold_left2 (fun acc (Arg (x, _)) v -> Env.add x v acc) rec_env params args_values in
        eval_expr new_env body
      | _ -> failwith "Appel de fonction invalide"
  

  (*Evaluation d'une instruction*)

  let eval_stat (env: env) (s: stat) (sortie: sortie) : sortie =
    match s with
    | ASTEcho expr ->
        let result = eval_expr env expr in
        (match result with
        | VInt n -> Printf.printf "%d\n" n
        | VBool b -> Printf.printf "%b\n" b
        | _ -> failwith "ECHO ne peut afficher que des entiers ou des booléens");
        result :: sortie
  

(* Évaluation d'une définition *)

let eval_def (env: env) (d: def) : env =
  match d with
  | ASTConst (x, _, e) -> Env.add x (eval_expr env e) env
  | ASTFun (f, _, args, e) -> Env.add f (VClosure (args, e, env)) env
  | ASTFunRec (f, _, args, e) -> 
    let rec_env = Env.add f (VRecClosure (f, args, e, env)) env in
    rec_env

(* Évaluation des commandes *)

let rec eval_cmds (env: env) (cmds: cmds) (sortie: sortie) : sortie =
  match cmds with
  | ASTStat s -> 
      let new_sortie = eval_stat env s sortie in
      new_sortie  (* Retourne la liste mise à jour *)
  | ASTDef (d, cmds) -> 
      let new_env = eval_def env d in
      eval_cmds new_env cmds sortie
    

(* Évaluation d'un programme *)

let eval_prog (cmds: cmds) : sortie =
  let results = eval_cmds Env.empty cmds [] in
  List.iter (fun v -> match v with
    | VInt n -> Printf.printf "Résultat: %d\n" n
    | VBool b -> Printf.printf "Résultat: %b\n" b
    | _ -> ()
  ) results;
  results
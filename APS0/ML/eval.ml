open Ast

module Env = Map.Make(String)

(* Type pour les valeurs manipulées *)
type valeur =
  | InZ of int
  | InF of expr * arg list * valeur Env.t  (* Fermeture pour les fonctions *)
  | InFR of  expr * string * arg list  * valeur Env.t  (* Fonction récursive *)

type env = valeur Env.t

let isBool b= 
  match b with
  | "true" -> true
  | "false" -> true
  | _ -> false

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
  | ASTId("add"), [InZ x; InZ y] -> InZ (x + y)
  | ASTId("sub"), [InZ x; InZ y] -> InZ (x - y)
  | ASTId("mul"), [InZ x; InZ y] -> InZ (x * y)
  | ASTId("div"), [InZ x; InZ y] when y <> 0 -> InZ (x / y)
  | ASTId("lt"), [InZ x; InZ y] -> InZ ( if x<y then 1 else 0)
  | ASTId("eq"), [InZ x; InZ y] -> InZ ( if x=y then 1 else 0)
  | ASTId("not"), [InZ b] -> InZ (if b=0 then 1 else 0)
  | _ -> failwith "Erreur d'évaluation de la primitive"

let evaluationBool b =
  match b with 
  | "true" -> InZ 1 
  | "false" -> InZ 0
  |_ -> failwith ("Pas bool")

(* Évaluation des expressions *)
let rec eval_expr (env: env) (e: expr) : valeur =
  match e with
  | ASTNum n -> InZ n

  | ASTId x -> (match (isBool x) with
    | true -> evaluationBool x
    | false -> (try Env.find x env with Not_found -> failwith ("Variable inconnue: " ^ x)))

  | ASTIf (cond, e1, e2) -> (
      match eval_expr env cond with
      | InZ 1 -> eval_expr env e1
      | InZ 0 -> eval_expr env e2
      | _ -> failwith "Condition non booléenne"
    )

  | ASTAnd (e1, e2) -> (
      match eval_expr env e1 with
      | InZ 1 -> eval_expr env e2 
      | InZ 0 -> InZ 0
      | _ -> failwith "Opérateurs and doivent être booléens"
    )

  | ASTOr (e1, e2) -> (
      match eval_expr env e1 with
      | InZ 0->  eval_expr env e2 
      | InZ 1 -> InZ 1
      | _ -> failwith "Opérateurs or doivent être booléens"
    )

  | ASTLambda (params, body) -> InF (body, params, env)

  | ASTApp (func, args) ->
    let args_values = List.map (fun arg -> eval_expr env arg) args in
    if est_primitive func then eval_primitive func args_values
    else
      let func_value = eval_expr env func in
      match func_value with
      | InF (body, params, closure_env) ->
        let new_env = List.fold_left2 (fun acc (Arg (x, _)) v -> Env.add x v acc) closure_env params args_values in
        eval_expr new_env body
      | InFR (body, name, params, closure_env) ->
        let rec_env = Env.add name (InFR (body, name, params, closure_env)) closure_env in
        let new_env = List.fold_left2 (fun acc (Arg (x, _)) v -> Env.add x v acc) rec_env params args_values in
        eval_expr new_env body
      | _ -> failwith "Appel de fonction invalide"
 

  (*Evaluation d'une instruction*)

  let eval_stat (env: env) (s: stat) (sortie: sortie) : sortie =
    match s with
    | ASTEcho expr ->
        let result = eval_expr env expr in
        (match result with
        | InZ n -> Printf.printf "%d\n" n
        | _ -> failwith "ECHO ne peut afficher que des entiers");
        result :: sortie
 

(* Évaluation d'une définition *)

let eval_def (env: env) (d: def) : env =
  match d with
  | ASTConst (x, _, e) -> Env.add x (eval_expr env e) env
  | ASTFun (f, _, args, e) -> Env.add f (InF ( e, args, env)) env
  | ASTFunRec (f, _, args, e) ->
    let rec_env = Env.add f (InFR (e, f, args, env)) env in
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
    | InZ n -> Printf.printf "Résultat: %d\n" n
    | _ -> ()
  ) results;
  results
	

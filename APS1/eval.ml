open Ast

(* Définition de la mémoire : adresse vers valeur entière *)
type address = int
let nextAddress = ref 0 


(* Type des valeurs *)
type valeur =
  | InZ of int  
  | InF of expr * arg list * env  
  | InFR of expr * string * arg list * env 
  | InA of address 
  | InP of cmds * arg list * env 
  | InPR of cmds * string * arg list * env 
 

and env = (string, valeur) Hashtbl.t


type memory = (address, int option) Hashtbl.t
module Memory = Hashtbl



(*Fonction pour allouer une adresse en mémoire*)

let alloc mem =
  let a = !nextAddress in
  nextAddress := a + 1;
  Hashtbl.add mem a None;
  a

(* Fonction pour modifier la valeur d'une adresse en mémoire *)
let store mem addr v =
  if Memory.mem mem addr then 
    Memory.replace mem addr (Some v)
  else
    failwith "Modification mémoire invalide : adresse non allouée"


(* Fonction de lecture mémoire *)
let load mem addr =
  try Memory.find mem addr
  with Not_found -> failwith "Accès mémoire invalide"

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

let rec eval_expr (env: env) (mem: memory) (e: expr) : valeur =
  match e with
  | ASTNum n -> InZ n 

  | ASTId x ->
      if isBool x then evaluationBool x
      else
        (match Hashtbl.find_opt env x with
         | Some (InA addr) ->  (* Si c'est une variable, on récupère la valeur en mémoire *)
             (match Hashtbl.find_opt mem addr with
              | Some (Some v) -> InZ v
              | Some None -> failwith (x ^ " : Variable non initialisée")
              | None -> failwith (x ^ " : Adresse non allouée"))
         | Some v -> v  (* Si c'est une constante, fonction ou procédure, on la retourne directement *)
         | None -> failwith (x ^ " : Variable ou fonction non définie dans l'environnement"))

  | ASTIf (cond, e1, e2) -> (
      match eval_expr env mem cond with
      | InZ 0 -> eval_expr env mem e2
      | InZ _ -> eval_expr env mem e1
      | _ -> failwith "Condition IF doit être booléenne"
    )

  | ASTAnd (e1, e2) -> (
      match eval_expr env mem e1 with
      | InZ 0 -> InZ 0
      | InZ _ -> eval_expr env mem e2
      | _ -> failwith "Les opérateurs AND doivent être booléens"
    )

  | ASTOr (e1, e2) -> (
      match eval_expr env mem e1 with
      | InZ 0 -> eval_expr env mem e2
      | InZ _ -> InZ 1
      | _ -> failwith "Les opérateurs OR doivent être booléens"
    )

  | ASTLambda (params, body) -> InF (body, params, env) 

  | ASTApp (func, args) ->
      let args_values = List.map (fun arg -> eval_expr env mem arg) args in
      if est_primitive func then eval_primitive func args_values
      else
        let func_value = eval_expr env mem func in
        match func_value with
        | InF (body, params, closure_env) -> 
            let new_env = Hashtbl.copy closure_env in
            List.iter2 (fun (Arg (x, _)) v -> Hashtbl.add new_env x v) params args_values;
            eval_expr new_env mem body
        | InFR (body, name, params, closure_env) ->
            let rec_env = Hashtbl.copy closure_env in
            Hashtbl.add rec_env name (InFR (body, name, params, rec_env));
            List.iter2 (fun (Arg (x, _)) v -> Hashtbl.add rec_env x v) params args_values;
            eval_expr rec_env mem body
        | _ -> failwith "Appel de fonction invalide"

  (*Evaluation d'une instruction*)


  and eval_stat (env: env) (mem: memory) (s: stat) (sortie: sortie) : memory * sortie =
    match s with
    | ASTEcho expr ->
        let result = eval_expr env mem expr in
        (match result with
        | InZ n -> (mem, InZ n :: sortie) 
        | _ -> failwith "ECHO ne peut afficher que des entiers")
  
    | ASTSet (x, e) ->
        let v = eval_expr env mem e in
        (match Hashtbl.find_opt env x with
          | Some (InA addr) ->  (* Si c'est une variable, on met à jour sa valeur en mémoire *)
            (match v with
              | InZ n -> 
                store mem addr n;  
                (mem, sortie) 
              | _ -> failwith "SET ne peut affecter que des entiers")
          | Some _ -> failwith (x ^ " est une constante ou une fonction, impossible de l'affecter")
          | None -> failwith (x ^ " : Variable non définie dans l'environnement"))      
    
    | ASTIfStat (cond, block1, block2) ->
        let cond_value = eval_expr env mem cond in
        (match cond_value with
        | InZ 1 -> eval_block env mem block1 sortie
        | InZ 0 -> eval_block env mem block2 sortie
        | _ -> failwith "Condition IF doit être booléenne")
  
    | ASTWhile (cond, block) ->
        let rec loop mem sortie =
          match eval_expr env mem cond with
          | InZ 1 ->
              let new_mem, new_sortie = eval_block env mem block sortie in
              loop new_mem new_sortie
          | InZ 0 -> (mem, sortie) 
          | _ -> failwith "Condition WHILE doit être booléenne"
        in loop mem sortie
  
    | ASTCall (p, args) ->
        (match Hashtbl.find_opt env p with
        | Some (InP (cmds, params, proc_env)) ->
            let args_values = List.map (fun arg -> eval_expr env mem arg) args in
            let new_env = Hashtbl.copy proc_env in
            List.iter2 (fun (Arg (x, _)) v -> Hashtbl.add new_env x v) params args_values;
            eval_block new_env mem (ASTBlock cmds) sortie
  
        | Some (InPR (cmds, rec_nom, params, proc_env)) ->
            let args_values = List.map (fun arg -> eval_expr env mem arg) args in
            let new_env = Hashtbl.copy proc_env in
            List.iter2 (fun (Arg (x, _)) v -> Hashtbl.add new_env x v) params args_values;
            Hashtbl.add new_env rec_nom (InPR (cmds, rec_nom, params, new_env));  
            eval_block new_env mem (ASTBlock cmds) sortie
  
        | _ -> failwith ("Procédure non définie: " ^ p))


        and eval_def (env: env) (mem: memory) (d: def) : env * memory =
          match d with
          | ASTConst (x, _, e) ->  
              let v = eval_expr env mem e in
              Hashtbl.add env x v;  (* Associe directement la valeur à la variable dans l'environnement *)
              (env, mem) 
        
          | ASTVar (x, _) ->  
              let addr = alloc mem in  
              Hashtbl.add env x (InA addr); 
              (env, mem)
        
          | ASTFun (f, _, args, e) ->
                let closure_env = Hashtbl.copy env in
                Hashtbl.add env f (InF (e, args, closure_env));
                (env, mem)
          
          | ASTFunRec (f, _, args, e) ->
                let rec_env = Hashtbl.copy env in
                let self_ref = InFR (e, f, args, rec_env) in
                Hashtbl.add rec_env f self_ref;
                Hashtbl.add env f self_ref;
                (env, mem)
        
          | ASTProc (p, args, ASTBlock block) ->  
              Hashtbl.add env p (InP (block, args, env)); 
              (env, mem)
        
          | ASTProcRec (p, args, ASTBlock block) ->  
              let rec_env = Hashtbl.copy env in  
              let self_ref = InPR (block, p, args, rec_env) in
              Hashtbl.add rec_env p self_ref;  
              Hashtbl.add env p self_ref;  
              (env, mem)
        
      

(* Évaluation d'une suite de commandes *)
and eval_cmds (env: env) (mem: memory) (cmds: cmds) (sortie: sortie) : memory * sortie =
  match cmds with
  | ASTDef (d, mCmds) ->  
      let new_env, new_mem = eval_def env mem d in  
      eval_cmds new_env new_mem mCmds sortie  

  | ASTStat s ->  
      let update_mem, update_sortie = eval_stat env mem s sortie in 
      (update_mem, update_sortie)  

  | ASTStatCMDS (s, cmds) ->  
      let intermediate_mem, intermediate_sortie = eval_stat env mem s sortie in  
      eval_cmds env intermediate_mem cmds intermediate_sortie 


and eval_block (env: env) (mem: memory) (block: Ast.block) (sortie: sortie) : memory * sortie =
    match block with
    | ASTBlock cmds -> eval_cmds env mem cmds sortie

(* Évaluation d'un programme *)

and eval_prog (block: Ast.block) : sortie =
  let env = Hashtbl.create 100 in  
  let mem = Memory.create 100 in  
  let _, sortie = eval_block env mem block [] in
  List.rev sortie

;;

	

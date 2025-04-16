open Ast

(* Types de base pour APS2 *)
type address = int

and valeur =
  | InZ of int
  | InB of address * int
  | InA of address
  | InF of expr * arg list * env
  | InFR of expr * string * arg list * env
  | InP of cmds * argProc list * env
  | InPR of cmds * string * argProc list * env


and env = (string, valeur) Hashtbl.t
and memory = (address, valeur option) Hashtbl.t
and sortie = valeur list

let next_address = ref 0

let alloc (mem : memory) : address =
  let addr = !next_address in
  incr next_address;
  Hashtbl.add mem addr None;
  addr

  let allocn mem size =
    let addr = ref !next_address in  
    (* Vérifie si on peut allouer size cellules à partir de addr *)
    let rec can_allocate_from a =
      if a + size > 10000 then false
      else
        let all_free = ref true in
        for i = 0 to size - 1 do
          if Hashtbl.mem mem (a + i) then all_free := false
        done;
        !all_free
    in
  
    (* Trouve un bloc allouable en avançant *)
    while not (can_allocate_from !addr) do
      incr addr
    done;
  
    (* Alloue *)
    for i = 0 to size - 1 do
      Hashtbl.add mem (!addr + i) None
    done;
  
    next_address := !addr + size;
    (!addr, mem)
  

let store mem addr v =
  match v with
  | InZ _ | InB _ ->
      if Hashtbl.mem mem addr then Hashtbl.replace mem addr (Some v)
      else failwith "Adresse non allouée"
  | _ -> failwith "Mémoire ne stocke que des InZ/InB"

let load mem addr =
  match Hashtbl.find_opt mem addr with
  | Some (Some v) -> v
  | Some None -> failwith "Valeur non initialisée"
  | None -> failwith "Adresse non allouée"

let is_bool = function "true" | "false" -> true | _ -> false

let eval_bool = function "true" -> InZ 1 | "false" -> InZ 0 | _ -> failwith "bool invalide"

let est_primitive = function
  | ASTId s -> List.mem s ["add"; "sub"; "mul"; "div"; "eq"; "lt"; "not"]
  | _ -> false

let eval_primitive prim args =
  match prim, args with
  | ASTId "add", [InZ a; InZ b] -> InZ (a + b)
  | ASTId "sub", [InZ a; InZ b] -> InZ (a - b)
  | ASTId "mul", [InZ a; InZ b] -> InZ (a * b)
  | ASTId "div", [InZ a; InZ b] -> if b = 0 then failwith "Div/0" else InZ (a / b)
  | ASTId "eq",  [InZ a; InZ b] -> InZ (if a = b then 1 else 0)
  | ASTId "lt",  [InZ a; InZ b] -> InZ (if a < b then 1 else 0)
  | ASTId "not", [InZ a] -> InZ (if a = 0 then 1 else 0)
  | _ -> failwith "primitive mal typée"

  let rec eval_expr env mem e =
    match e with
    | ASTNum n -> (InZ n, mem)
    | ASTId x when is_bool x -> (eval_bool x, mem)
    | ASTId x -> (
        match Hashtbl.find_opt env x with
        | Some (InA a) -> (load mem a, mem)
        | Some v -> (v, mem)
        | None -> failwith (x ^ " non défini")
      )
  
    | ASTIf (cond, et, ef) ->
        let (vc, m1) = eval_expr env mem cond in
        (match vc with
         | InZ 0 -> eval_expr env m1 ef
         | InZ _ -> eval_expr env m1 et
         | _ -> failwith "IF : condition non booléenne")
  
    | ASTAnd (e1, e2) ->
        let (v1, m1) = eval_expr env mem e1 in
        (match v1 with
         | InZ 0 -> (InZ 0, m1)
         | InZ _ -> eval_expr env m1 e2
         | _ -> failwith "AND : opérande non booléen")
  
    | ASTOr (e1, e2) ->
        let (v1, m1) = eval_expr env mem e1 in
        (match v1 with
         | InZ 0 -> eval_expr env m1 e2
         | InZ _ -> (InZ 1, m1)
         | _ -> failwith "OR : opérande non booléen")
  
    | ASTAlloc e1 ->
        let (v1, m1) = eval_expr env mem e1 in
        (match v1 with
         | InZ n ->
             let (base, m2) = allocn m1 n in
             (InB (base, n), m2)
         | _ -> failwith "Alloc : taille non entière")
  
    | ASTVset (e1, e2, e3) ->
        let (v1, m1) = eval_expr env mem e1 in
        (match v1 with
         | InB (base, size) ->
             let (v2, m2) = eval_expr env m1 e2 in
             let (v3, m3) = eval_expr env m2 e3 in
             (match v2 with
              | InZ idx ->
                  if idx < 0 || idx >= size then (
                    failwith "Index hors limites"
                  );
                  store m3 (base + idx) v3;
                  (v1, m3)
              | _ -> failwith "vset : index non entier")
         | _ -> failwith "vset : e1 n est pas un bloc mémoire")
  
    | ASTLen e1 ->
        let (v1, m1) = eval_expr env mem e1 in
        (match v1 with
         | InB (_, size) -> (InZ size, m1)
         | _ -> failwith "len : e1 n est pas un bloc mémoire")
  
    | ASTNth (e1, e2) ->
        let (v1, m1) = eval_expr env mem e1 in
        let (v2, m2) = eval_expr env m1 e2 in
        (match v1, v2 with
         | InB (base, size), InZ idx ->
             if idx < 0 || idx >= size then (
               failwith "Index hors limites"
             );
             (load m2 (base + idx), m2)
         | _ -> failwith "nth : types invalides")
  
    | ASTLambda (params, body) ->
        (InF (body, params, env), mem)
  
    | ASTApp (f, args) ->
          let rec eval_args acc mem args =
            match args with
            | [] -> (List.rev acc, mem)
            | e :: rest ->
                let (v, m') = eval_expr env mem e in
                eval_args (v :: acc) m' rest
          in
          let (arg_vals, m1) = eval_args [] mem args in
          if est_primitive f then
            (eval_primitive f arg_vals, m1)
          else
            let (vf, m2) = eval_expr env m1 f in
            match vf with
            | InF (body, params, closure) ->
                let new_env = Hashtbl.copy closure in
                List.iter2 (fun (Arg (x, _)) v -> Hashtbl.add new_env x v) params arg_vals;
                eval_expr new_env m2 body
            | InFR (body, name, params, closure) ->
                let rec_env = Hashtbl.copy closure in
                let self = InFR (body, name, params, rec_env) in
                Hashtbl.add rec_env name self;
                List.iter2 (fun (Arg (x, _)) v -> Hashtbl.add rec_env x v) params arg_vals;
                eval_expr rec_env m2 body
            | _ -> failwith "Appel invalide : fonction non trouvée"      
  
(* Evaluation d'une variable ou d'un tableau *)
and eval_lval (env : env) (mem : memory) (lv : lval) : address * memory =
  match lv with
  | ASTLvalIdent x -> (
      match Hashtbl.find_opt env x with
      | Some (InA addr) -> (addr, mem)
      | _ -> failwith (x ^ " : Variable non assignable"))

  | ASTLvalNth (ASTLvalIdent x, idx_expr) -> (
      match Hashtbl.find_opt env x with
      | Some (InB (base, size)) ->  (* x est directement un vecteur *)
          let (idx, mem1) = eval_expr env mem idx_expr in
          (match idx with
            | InZ i when i >= 0 && i < size -> (base + i, mem1)
            | _ -> failwith (x ^ " : Index invalide dans tableau"))

      | Some (InA addr) ->          (* x est une variable contenant un bloc *)
          (match Hashtbl.find_opt mem addr with
           | Some (Some (InB (base, size))) ->
               let (idx, mem1) = eval_expr env mem idx_expr in
               (match idx with
                | InZ i when i >= 0 && i < size -> (base + i, mem1)
                | _ -> failwith (x ^ " : Index invalide dans tableau"))
           | Some _ -> failwith (x ^ " : La variable ne contient pas un bloc")
           | None -> failwith (x ^ " : Adresse non allouée"))
           
      | _ -> failwith (x ^ " : Variable non trouvée dans l’environnement"))

  | ASTLvalNth (lv1, idx_expr) ->
      let (a1, mem1) = eval_lval env mem lv1 in
      (match Hashtbl.find_opt mem1 a1 with
       | Some (Some(InB (base, size))) ->
           let (idx, mem2) = eval_expr env mem1 idx_expr in
           (match idx with
            | InZ i when i >= 0 && i < size -> (base + i, mem2)
            | _ -> failwith "Index invalide dans tableau imbriqué")
       | _ -> failwith "Mémoire ne contient pas un bloc")

(* Evaluation d'une expression ou d'une procédure *)
  and eval_exprProc env mem ep =
    match ep with
      | ASTExpr e -> eval_expr env mem e
      | ASTExprProc id -> (
          match Hashtbl.find_opt env id with
            | Some (InA addr) -> (InA addr, mem)
            | _ -> failwith (id ^ " : attendu une variable (adresse)")
          )
   
  (* Evaluation d'une instruction *)
  and eval_stat (env : env) (mem : memory) (s : stat) (out : sortie) : memory * sortie =
        match s with
        | ASTEcho e ->
            let (v, mem1) = eval_expr env mem e in
            (match v with
             | InZ n -> (mem1, InZ n :: out)
             | _ -> failwith "ECHO ne peut afficher que des entiers")
      
        | ASTSet (lv, e) ->
            let (addr, mem1) = eval_lval env mem lv in
            let (v, mem2) = eval_expr env mem1 e in
            (match v with
             | InZ _ | InB _ ->
                 store mem2 addr v;
                 (mem2, out)
             | _ -> failwith "SET : type non mémorisable")
      
        | ASTIfStat (cond, b1, b2) ->
            let (vc, mem1) = eval_expr env mem cond in
            (match vc with
             | InZ 1 -> eval_block env mem1 b1 out
             | InZ 0 -> eval_block env mem1 b2 out
             | _ -> failwith "IF : condition non booléenne")
      
        | ASTWhile (cond, body) ->
            let rec loop mem_acc out_acc =
              let (vc, mem1) = eval_expr env mem_acc cond in
              match vc with
              | InZ 1 ->
                  let (mem2, out2) = eval_block env mem1 body out_acc in
                  loop mem2 out2
              | InZ 0 -> (mem_acc, out_acc)
              | _ -> failwith "WHILE : condition non booléenne"
            in
            loop mem out
      
        | ASTCall (pname, args) ->
            match Hashtbl.find_opt env pname with
            | Some (InP (cmds, params, closure_env))
            | Some (InPR (cmds, _, params, closure_env)) ->
                (* Vérifie que le nombre d'arguments et de paramètres correspond *)
                if List.length args <> List.length params then
                  failwith (pname ^ " : mauvais nombre d'arguments");
      
                (* Associe chaque paramètre à son argument en évaluant selon le mode *)
                let rec eval_args acc mem ps as_ =
                  match ps, as_ with
                  | [], [] -> (List.rev acc, mem)
                  | ASTArgProc (x, _) :: ps', ASTExpr e :: as' ->
                      let (v, m') = eval_expr env mem e in
                      eval_args ((x, v) :: acc) m' ps' as'
                  | ASTArgProcVar (x, _) :: ps', ASTExprProc id :: as' -> (
                      match Hashtbl.find_opt env id with
                      | Some (InA addr) -> eval_args ((x, InA addr) :: acc) mem ps' as'
                      | _ -> failwith (id ^ " : attendu une variable (adresse)")
                    )
                  | _ -> failwith "Appel procédure : arguments non compatibles"
                in
      
                let (bindings, mem1) = eval_args [] mem params args in
      
                (* création de l’environnement local *)
                let local_env = Hashtbl.copy closure_env in
                List.iter (fun (x, v) -> Hashtbl.add local_env x v) bindings;
      
                (match Hashtbl.find_opt env pname with
                 | Some (InPR _) ->
                     Hashtbl.replace local_env pname (InPR (cmds, pname, params, local_env))
                 | _ -> ());
      
                (* on évalue le corps de la procédure *)
                eval_block local_env mem1 (ASTBlock cmds) out
      
            | _ -> failwith (pname ^ " : Procédure non définie")
      
(* Evaluation d'une définition *)
and eval_def (env : env) (mem : memory) (d : def) : env * memory =
  match d with
  | ASTConst (x, _, e) ->
      let (v, mem1) = eval_expr env mem e in
      Hashtbl.add env x v;
      (env, mem1)
  | ASTVar (x, _) ->
      let addr = alloc mem in
      Hashtbl.add env x (InA addr);
      (env, mem)
  | ASTFun (f, _, args, body) ->
      let closure_env = Hashtbl.copy env in
        let vf = InF (body, args, closure_env) in
        Hashtbl.add env f vf;
        (env, mem)
    
  | ASTFunRec (f, _, args, body) ->
      let rec_env = Hashtbl.copy env in
        let self = InFR (body, f, args, rec_env) in
        Hashtbl.add rec_env f self;
        Hashtbl.add env f self;
        (env, mem)
    
  | ASTProc (p, args, ASTBlock cmds) ->
      Hashtbl.add env p (InP (cmds, args, env));
      (env, mem)
  | ASTProcRec (p, args, ASTBlock cmds) ->
      let rec_env = Hashtbl.copy env in
      let self = InPR (cmds, p, args, rec_env) in
      Hashtbl.add rec_env p self;
      Hashtbl.add env p self;
      (env, mem)

(* Evaluation d'une suite de commandes *)
and eval_cmds (env : env) (mem : memory) (cmds : cmds) (out : sortie) : memory * sortie =
  match cmds with
  | ASTStat s -> eval_stat env mem s out
  | ASTDef (d, cs) ->
      let env1, mem1 = eval_def env mem d in
      eval_cmds env1 mem1 cs out
  | ASTStatCMDS (s, cs) ->
      let mem1, out1 = eval_stat env mem s out in
      eval_cmds env mem1 cs out1

  (*evaluation d'un bloc de commandes*)
and eval_block (env : env) (mem : memory) (block : block) (out : sortie) : memory * sortie =
  match block with
  | ASTBlock cs -> eval_cmds env mem cs out

  (* évaluation d'un programme *)
and eval_prog (b : block) : sortie =
  let env = Hashtbl.create 100 in
  let mem = Hashtbl.create 100 in
  let _, out = eval_block env mem b [] in
  List.rev out

(* ========================================================================== *)
(* == UPMC/master/info/4I506 -- Janvier 2016/2017/2018                     == *)
(* == SU/FSI/master/info/MU4IN503 -- Janvier 2020/2021/2022                == *)
(* == Analyse des programmes et sémantiques                                == *)
(* ========================================================================== *)
(* == hello-APS Syntaxe ML                                                 == *)
(* == Fichier: test.ml                                               == *)
(* ==  Génération de termes Prolog                                         == *)
(* ========================================================================== *)


open Ast

let rec print_typ t =
  match t with
  | BaseType TInt -> Printf.printf "int"
  | BaseType TBool -> Printf.printf "bool"
  | ASTArrow(args, ret) ->
      Printf.printf "arrow([";
      print_typs args;
      Printf.printf "],";
      print_typ ret;
      Printf.printf ")"

and print_typs ts =
  match ts with
  | [] -> ()
  | [t] -> print_typ t
  | t::trs ->
      print_typ t;
      Printf.printf ",";
      print_typs trs

let print_arg (Arg(name, t)) =
  Printf.printf "(%s" name;
  Printf.printf ",";
  print_typ t;
  Printf.printf ")"

let rec print_args args =
  match args with
  | [] -> ()
  | [a] -> print_arg a
  | a::as' ->
      print_arg a;
      Printf.printf ",";
      print_args as'

let rec print_expr e =
  match e with
  | ASTNum n -> Printf.printf "num(%d)" n
  | ASTId id -> Printf.printf "id(%s)" id
  | ASTIf(cond, cons, alt) ->
      Printf.printf "if(";
      print_expr cond;
      Printf.printf ",";
      print_expr cons;
      Printf.printf ",";
      print_expr alt;
      Printf.printf ")"
  | ASTAnd(e1, e2) ->
      Printf.printf "and(";
      print_expr e1;
      Printf.printf ",";
      print_expr e2;
      Printf.printf ")"
  | ASTOr(e1, e2) ->
      Printf.printf "or(";
      print_expr e1;
      Printf.printf ",";
      print_expr e2;
      Printf.printf ")"
  | ASTApp(e, es) ->
      Printf.printf "app(";
      print_expr e;
      Printf.printf ",[";
      print_exprs es;
      Printf.printf "])"
  | ASTLambda(args, e) ->
      Printf.printf "lambda([";
      print_args args;
      Printf.printf "],";
      print_expr e;
      Printf.printf ")"

and print_exprs es =
  match es with
  | [] -> ()
  | [e] -> print_expr e
  | e::es' ->
      print_expr e;
      Printf.printf ",";
      print_exprs es'

let print_stat s =
  match s with
  | ASTEcho e ->
      Printf.printf "echo(";
      print_expr e;
      Printf.printf ")"

let print_def d =
  match d with
  | ASTConst(id, t, e) ->
      Printf.printf "const(%s," id;
      print_typ t;
      Printf.printf ",";
      print_expr e;
      Printf.printf ")"
  | ASTFun(id, t, args, e) ->
      Printf.printf "fun(%s," id;
      print_typ t;
      Printf.printf ",[";
      print_args args;
      Printf.printf "],";
      print_expr e;
      Printf.printf ")"
  | ASTFunRec(id, t, args, e) ->
      Printf.printf "funRec(%s," id;
      print_typ t;
      Printf.printf ",[";
      print_args args;
      Printf.printf "],";
      print_expr e;
      Printf.printf ")"

let rec print_cmds c =
  match c with
  | ASTStat s -> print_stat s
  | ASTDef(d, c') ->
      Printf.printf "cmds(";
      print_def d;
      Printf.printf "),";
      print_cmds c'

let print_prog p =
  Printf.printf "prog([";
  print_cmds p;
  Printf.printf "])"
;;
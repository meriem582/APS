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
  | BaseType TVoid -> Printf.printf "void"
  | ASTArrow(args, ret) ->
      Printf.printf "arrow([";
      print_typs args;
      Printf.printf "],";
      print_typ ret;
      Printf.printf ")"
  | ASTVec(t) ->
      Printf.printf "vec(";
      print_typ t;
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

let print_arg_proc arg =
    match arg with
    | ASTArgProc(name, t) -> (
        Printf.printf "(arg(%s)" name;
        Printf.printf ",";
        print_typ t;
        Printf.printf ")" )
    | ASTArgProcVar(name, t) -> (
        Printf.printf "(argVar(%s)" name;
        Printf.printf ",";
        print_typ t;
        Printf.printf ")" )

        

let rec print_args_proc args =
  match args with
  | [] -> ()
  | [a] -> print_arg_proc a
  | a::as' ->
      print_arg_proc a;
      Printf.printf ",";
      print_args_proc as'
  


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
      print_exprs_proc es;
      Printf.printf "])"
  | ASTLambda(args, e) ->
      Printf.printf "lambda([";
      print_args args;
      Printf.printf "],";
      print_expr e;
      Printf.printf ")"
  | ASTAlloc e ->
      Printf.printf "alloc(";
      print_expr e;
      Printf.printf ")"
  | ASTLen e ->
      Printf.printf "len(";
      print_expr e;
      Printf.printf ")"
  | ASTNth (e1, e2) ->
      Printf.printf "nth(";
      print_expr e1;
      Printf.printf ",";
      print_expr e2;
      Printf.printf ")"
  | ASTVset (e1, e2, e3) ->
      Printf.printf "vset(";
      print_expr e1;
      Printf.printf ",";
      print_expr e2;
      Printf.printf ",";
      print_expr e3;
      Printf.printf ")"

and print_exprs es =
  match es with
  | [] -> ()
  | [e] -> print_expr e
  | e::es' ->
      print_expr e;
      Printf.printf ",";
      print_exprs es'
      

and print_expr_proc ep =
  match ep with
  | ASTExprProc(lvalue) ->
    Printf.printf "exprProc";
    Printf.printf "(";
    print_lval lvalue;
    Printf.printf ")"
  | ASTExpr(e) -> print_expr e  

and print_exprs_proc es =
    match es with
    | [] -> ()
    | [e] -> print_expr_proc e
    | e::es' ->(
        print_expr_proc e;
        Printf.printf ",";
        print_exprs_proc es' )

and print_lval l =
  match l with
  | ASTLvalIdent id -> Printf.printf "id(%s)" id
  | ASTLvalNth(l, e) ->
      Printf.printf "lvalNth(";
      print_lval l;
      Printf.printf ",";
      print_expr e;
      Printf.printf ")"

and print_stat s =
  match s with
  | ASTEcho e ->
      Printf.printf "echo(";
      print_expr e;
      Printf.printf ")"
  | ASTSet(lvalue, e) ->
      Printf.printf "set(";
      print_lval lvalue;
      Printf.printf ",";
      print_expr e;
      Printf.printf ")"
  | ASTIfStat(cond, bk1, bk2) -> 
      Printf.printf "ifStat(";
      print_expr cond;
      Printf.printf ",";
      print_block bk1;
      Printf.printf ",";
      print_block bk2;
      Printf.printf ")"
  | ASTWhile(cond, bk) ->
      Printf.printf "while(";
      print_expr cond;
      Printf.printf ",";
      print_block bk;
      Printf.printf ")"
  | ASTCall(id, es) ->
      Printf.printf "call(id(%s),[" id;
      print_exprs_proc es;
      Printf.printf "])"

and print_def d =
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
  | ASTVar(id, t) ->
      Printf.printf "var(%s," id;
      print_typ t;
      Printf.printf ")"
  | ASTProc(id, args, bk) ->
      Printf.printf "proc(%s,[" id;
      print_args_proc args;
      Printf.printf "],";
      print_block bk;
      Printf.printf ")"
  | ASTProcRec(id, args, bk) ->
      Printf.printf "procRec(%s,[" id;
      print_args_proc args;
      Printf.printf "],";
      print_block bk;
      Printf.printf ")"
  | ASTFunDec(id, t, args, bk) ->
      Printf.printf "funBlock(%s," id;
      print_typ t;
      Printf.printf ",[";
      print_args_proc args;
      Printf.printf "],";
      print_block bk;
      Printf.printf ")"
  
  | ASTFunRecDec(id, t, args, bk) ->
      Printf.printf "funRecBlock(%s," id;
      print_typ t;
      Printf.printf ",[";
      print_args_proc args;
      Printf.printf "],";
      print_block bk;
      Printf.printf ")"

and print_ret r =
  match r with
  | ASTRet e ->
      Printf.printf "return(";
      print_expr e;
      Printf.printf ")"

and print_cmds c =
  match c with
  | ASTStat s -> print_stat s
  | ASTDef(d, c') ->
      Printf.printf "cmds(";
      print_def d;
      Printf.printf "),";
      print_cmds c'
  | ASTStatCMDS(s, c') ->
      print_stat s;
      Printf.printf ",";
      print_cmds c'
   | ASTRetCMDS(r) -> (print_ret r;)

  
and print_block b =
  match b with
  | ASTBlock(c) ->
      Printf.printf "block([";
      print_cmds c;
      Printf.printf "])"

and print_prog p =
      Printf.printf "prog(";
      print_block p;
      Printf.printf ")"
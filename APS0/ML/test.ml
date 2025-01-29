(* ========================================================================== *)
(* == UPMC/master/info/4I506 -- Janvier 2016/2017/2018                     == *)
(* == SU/FSI/master/info/MU4IN503 -- Janvier 2020/2021/2022                == *)
(* == Analyse des programmes et sémantiques                                == *)
(* ========================================================================== *)
(* == hello-APS Syntaxe ML                                                 == *)
(* == Fichier: prologTerm.ml                                               == *)
(* ==  Génération de termes Prolog                                         == *)
(* ========================================================================== *)
open Ast
  
let rec print_expr e =
  match e with
      ASTNum n -> Printf.printf"num(%d)" n
    | ASTId x -> Printf.printf"id(%s)" x
    | ASTIf(cond,thn,els) -> (
      Printf.printf"if(";
      print_expr cond;
      Printf.printf",";
      print_expr thn;
      Printf.printf",";
      print_expr els;
      Printf.printf")"
    )
    | ASTAnd(e1,e2) -> (
      Printf.printf"and(";
      print_expr e1;
      Printf.printf",";
      print_expr e2;
      Printf.printf")"
    )
    | ASTOr(e1,e2) -> (
      Printf.printf"or(";
      print_expr e1;
      Printf.printf",";
      print_expr e2;
      Printf.printf")"
    )                       
    | ASTApp(e1,e2) -> (
      Printf.printf"app(";
      print_expr e1;
      Printf.printf",[";
      print_exprs e2;
      Printf.printf"])"
    )
    | ASTLambda(args,e) -> (
      Printf.printf"lambda([";
      print_args args;
      Printf.printf"],";
      print_expr e;
      Printf.printf")"
    )
and print_exprs es =
  match es with
      [] -> ()
    | [e] -> print_expr e
    | e::es -> (
	print_expr e;
	print_char ',';
	print_exprs es
      )

let print_stat s =
  match s with
      ASTEcho e -> (
	Printf.printf("echo (");
	print_expr(e);
  Printf.printf(")")
      )

let print_def d =
  match d with
    |ASTConst(iden,t,value) -> (
      Printf.printf("const(%s,",iden);
      print_typ t;
      Printf.printf(",");
      print_expr value;
      Printf.printf(")")
      )
    | ASTFun(iden,t,args,e) -> (
      Printf.printf("fun(%s,",iden);
      print_typ t;
      Printf.printf(",[");
      print_args args;
      Printf.printf("],");
      print_expr e;
      Printf.printf(")")
      )
    | ASTRec(iden,t,args,e) -> (
      Printf.printf("rec(%s,",iden);
      print_typ t;
      Printf.printf(",[");
      print_args args;
      Printf.printf("],");
      print_expr e;
      Printf.printf(")")
      )
	
let rec print_cmds cs =
  match cs with
    ASTStat s -> print_stat s
    | ASTdef(d,c) -> (
      print_def d;
      Printf.printf(",");
      print_cmds c
      )
	
let print_prog p =
  Printf.printf("prog([");
  print_cmds p;
  Printf.printf("])")
;;
    
(*fonction pour afficher les types*)

let rec print_typ t =
  match t with
      Int -> Printf.printf"int"
    | Bool -> Printf.printf"bool"
    | ASTArrow(t1,t2) -> (
    Printf.printf"arrow([";
    print_typs t1;
    Printf.printf"] ,";
    print_typ t2;
    Printf.printf")"
    )

let rec print_typs ts =
  match ts with
      ASTTyp t -> print_typ t
    | ASTTyps(t,ts) -> (
    print_typ t;
    Printf.printf",";
    print_typs ts
    )

(*fonctions pour afficher les arguments*)

let print_arg a =
  match a with
      ASTArg(s,t) -> (
    Printf.printf"arg(%s," s;
    print_typ t;
    Printf.printf")"
    )

let rec print_args ass =  
  match ass with
      ASTArgs a -> print_arg a
    | ASTArgs(a,ass) -> (
    print_arg a;
    Printf.printf",";
    print_args ass
    )



let fname = Sys.argv.(1) in
let ic = open_in fname in
  try
    let lexbuf = Lexing.from_channel ic in
      let p = Parser.prog Lexer.token lexbuf in
        print_prog p;
        print_string ".\n"
    with Lexer.Eof ->
      exit 0     esult =
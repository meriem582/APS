open Ast
open Eval

(* Lit un fichier et génère l'AST *)
let parse_program filename =
  let chan = open_in filename in
  let lexbuf = Lexing.from_channel chan in
  try
    let ast = Parser.prog Lexer.token lexbuf in
    close_in chan;
    ast
  with
  | Lexer.Eof -> failwith "Erreur : fin de fichier inattendue"
  | Parser.Error -> failwith "Erreur de parsing"

(* Exécute et affiche les résultats *)
let () =
  if Array.length Sys.argv < 2 then
    print_endline "Usage: ./test <fichier.aps>"
  else
    let ast = parse_program Sys.argv.(1) in
    eval_prog ast;
    print_endline "Programme exécuté avec succès !"

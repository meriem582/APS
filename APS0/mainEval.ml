open Ast
open Eval  (* On importe le module eval *)

(* Vérification que l'utilisateur a bien fourni un argument *)
let () =
  if Array.length Sys.argv < 2 then (
    Printf.printf "Usage : %s <fichier>\n" Sys.argv.(0);
    exit 1
  );

let fname = Sys.argv.(1) in
let ic = open_in fname in
try
  let lexbuf = Lexing.from_channel ic in
  let p =
    try
      Parser.prog Lexer.token lexbuf
    with
    | Parsing.Parse_error ->
        let open Lexing in
        let curr = lexbuf.lex_curr_p in
        let line = curr.pos_lnum in
        let cnum = curr.pos_cnum - curr.pos_bol in
        Printf.printf "Erreur de syntaxe à la ligne %d, colonne %d\n" line cnum;
        exit 1
  in
  let _ = eval_prog p in
  Printf.printf "Évaluation terminée avec succès.\n"
  
with
| Lexer.Eof -> Printf.printf "Erreur : fin de fichier inattendue.\n"
| Sys_error msg -> Printf.printf "Erreur système : %s\n" msg; exit 1
| Failure msg -> Printf.printf "Erreur interne : %s\n" msg; exit 1
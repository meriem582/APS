open Ast
open Eval  (* Ton module Eval *)

let () =
  if Array.length Sys.argv < 2 then (
    Printf.printf "Usage : %s <fichier>\n" Sys.argv.(0);
    exit 1
  );

  let fname = Sys.argv.(1) in
  let ic = open_in fname in
  try
    let lexbuf = Lexing.from_channel ic in
    let prog =
      try
        Parser.prog Lexer.token lexbuf
      with
      | Parsing.Parse_error ->
          let open Lexing in
          let curr = lexbuf.lex_curr_p in
          let line = curr.pos_lnum in
          let col = curr.pos_cnum - curr.pos_bol in
          Printf.printf "Erreur de syntaxe à la ligne %d, colonne %d\n" line col;
          exit 1
    in

    let result = eval_prog prog in
    List.iter (function
      | InZ n -> Printf.printf "%d\n" n
      | _ -> ()
    ) result;

    Printf.printf "Évaluation terminée avec succès.\n"

  with
  | Lexer.Eof ->
      Printf.printf "Erreur : fin de fichier inattendue.\n"
  | Sys_error msg ->
      Printf.printf "Erreur système : %s\n" msg; exit 1
  | Failure msg ->
      Printf.printf "Erreur interne : %s\n" msg; exit 1

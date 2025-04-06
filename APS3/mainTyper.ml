(*fichier fait avec l'aide de chatGPT pour parser un fichier et generer son ast*)

open Prologterm
open Parser
open Lexer
open Ast
open Lexing
open Sys

let read_file filename =
  let ic = open_in filename in
  try
    let content = really_input_string ic (in_channel_length ic) in
    close_in ic;
    content
  with e ->
    close_in_noerr ic;
    raise e

let parse_and_print filename =
  let input_code = read_file filename in
  let lexbuf = Lexing.from_string input_code in
  try
    let p = Parser.prog Lexer.token lexbuf in
    print_prog p  
  with
  | Lexer.Eof ->
      Printf.eprintf "Lexer error: unexpected EOF in file %s\n" filename
  | Parsing.Parse_error ->
      Printf.eprintf "Parser error: syntax issue in file %s\n" filename

let () =
  if Array.length Sys.argv < 2 then
    Printf.eprintf "Usage: %s <filename>\n" Sys.argv.(0)
  else
    let filename = Sys.argv.(1) in
    parse_and_print filename

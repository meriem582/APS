(* ========================================================================== *)
(* == UPMC/master/info/4I506 -- Janvier 2016/2017/2018                     == *)
(* == SU/FSI/master/info/MU4IN503 -- Janvier 2020/2021/2022                == *)
(* == Analyse des programmes et sémantiques                                == *)
(* ========================================================================== *)
(* == hello-APS Syntaxe ML                                                 == *)
(* == Fichier: lexer.mll                                                   == *)
(* ==  Lexique                                                             == *)
(* ========================================================================== *)

{
  open Parser        (* The type token is defined in parser.mli *)
  exception Eof
}
let integer = ('-'?)['0'-'9']+

let ident = ['a'-'z''A'-'Z'](['a'-'z''A'-'Z''0'-'9'])*

rule token = parse
    [' ' '\t' '\n']       { token lexbuf }     (* skip blanks *)
  (* symbole réservés *)
  | '['              { LBRA }
  | ']'              { RBRA }
  | '('              { LPAR }
  | ')'              { RPAR }
  | ';'              { SEMICOLON }
  | ':'              { COLON }
  | ','              { COMMA }  
  | '*'              { STAR }
  | "->"             { ARROW }
  (*mots clés*)
  | "CONST"          { CONST }
  | "FUN"            { FUN }
  | "REC"            { REC }
  | "ECHO"           { ECHO }
  | "if"             { IF }
  | "and"            { AND }
  | "or"             { OR }
  | "bool"           { BOOL }
  | "int"            { INT } 
  (* constantes numériques *)
  | integer as lxm   { NUM(int_of_string lxm) }
  (* identificateurs *)
  | ident as lxm     { IDENT(lxm) }
  (* symboles primitifs *)
  | "true"           { TRUE }
  | "false"          { FALSE }
  | "not"            { NOT }
  | "eq"             { EQ }
  | "lt"             { LT }
  | "add"            { PLUS }
  | "sub"            { MINUS }
  | "mul"            { TIMES }
  | "div"            { DIV }
  (* fin de fichier *)
  | eof              { raise Eof }

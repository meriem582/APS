    {
    open Parser
    exception Eof
    }


    rule token = parse
        [' ' '\t' '\n' '\r']+ { token lexbuf }
    | '[' { Printf.printf "LEXER: Détecté [\n"; LBRA }
    | ']' { Printf.printf "LEXER: Détecté ]\n"; RBRA }
    | '(' { Printf.printf "LEXER: Détecté (\n"; LPAR }
    | ')' { Printf.printf "LEXER: Détecté )\n"; RPAR }
    | ';' { Printf.printf "LEXER: Détecté ;\n"; SEMCOL }
    | ':' { Printf.printf "LEXER: Détecté :\n"; COL }
    | ',' { Printf.printf "LEXER: Détecté ,\n"; COMA }
    | '*' { Printf.printf "LEXER: Détecté *\n"; STAR }
    | "->" { Printf.printf "LEXER: Détecté ->\n"; ARROW }
    | "CONST" { Printf.printf "LEXER: Détecté CONST\n"; CONST }
    | "FUN" { Printf.printf "LEXER: Détecté FUN\n"; FUN }
    | "REC" { Printf.printf "LEXER: Détecté REC\n"; REC }
    | "ECHO" { Printf.printf "LEXER: Détecté ECHO\n"; ECHO }
    | "if" { Printf.printf "LEXER: Détecté if\n"; IF }
    | "and" { Printf.printf "LEXER: Détecté and\n"; AND }
    | "or" { Printf.printf "LEXER: Détecté or\n"; OR }
    | "bool" { Printf.printf "LEXER: Détecté bool\n"; BOOL }
    | "int" { Printf.printf "LEXER: Détecté int\n"; INT }
    | ('-'?)['0'-'9']+ as num { Printf.printf "LEXER: Détecté NUM %s\n" num; NUM (int_of_string num) }
    | ['a'-'z''A'-'Z'](['a'-'z''A'-'Z''0'-'9'])* as id { Printf.printf "LEXER: Détecté IDENT %s\n" id; IDENT id }
    | eof { Printf.printf "LEXER: Fin de fichier\n"; raise Eof }


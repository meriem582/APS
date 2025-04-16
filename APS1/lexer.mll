    {
    open Parser
    exception Eof
    }


    rule token = parse
        [' ' '\t' '\n' '\r']+ { token lexbuf }
    | '[' { LBRA }
    | ']' { RBRA }
    | '(' { LPAR }
    | ')' { RPAR }
    | ';' { SEMCOL }
    | ':' { COL }
    | ',' { COMA }
    | '*' { STAR }
    | "->" { ARROW }
    | "CONST" {  CONST }
    | "FUN" {  FUN }
    | "REC" { REC }
    | "ECHO" { ECHO }
    | "if" { IF }
    | "and" { AND }
    | "or" {  OR }
    | "bool" {  BOOL }
    | "int" {  INT }
    (*Rajouter pour APS1*)
    | "void" {  VOID }
    | "IF" { IFSTAT }
    | "SET" { SET }
    | "WHILE" { WHILE }
    | "VAR" { VAR }
    | "PROC" { PROC }
    | "CALL" { CALL }
    
    | ('-'?)['0'-'9']+ as num { NUM (int_of_string num) }
    | ['a'-'z''A'-'Z'](['a'-'z''A'-'Z''0'-'9'])* as id { IDENT id }
    | eof { raise Eof }
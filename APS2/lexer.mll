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
    | "void" {  VOID }
    | "IF" { IFSTAT }
    | "SET" { SET }
    | "WHILE" { WHILE }
    | "VAR" { VAR }
    | "var"  { VARA }
    | "adr" { ADR }
    | "PROC" { PROC }
    | "CALL" { CALL }
    | "vec" { VEC }
    | "alloc" { ALLOC }
    | "nth" { NTH }
    | "len" { LEN }
    | "vset" { VSET }
    
    | ('-'?)['0'-'9']+ as num { NUM (int_of_string num) }
    | ['a'-'z''A'-'Z'](['a'-'z''A'-'Z''0'-'9'])* as id { IDENT id }
    | eof { raise Eof }
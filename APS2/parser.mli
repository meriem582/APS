type token =
  | LBRA
  | RBRA
  | LPAR
  | RPAR
  | SEMCOL
  | COL
  | COMA
  | ARROW
  | STAR
  | CONST
  | FUN
  | REC
  | ECHO
  | IF
  | AND
  | OR
  | BOOL
  | INT
  | SET
  | VAR
  | VARA
  | ADR
  | WHILE
  | PROC
  | CALL
  | VOID
  | IFSTAT
  | VEC
  | ALLOC
  | NTH
  | LEN
  | VSET
  | NUM of (
# 8 "parser.mly"
        int
# 38 "parser.mli"
)
  | IDENT of (
# 9 "parser.mly"
        string
# 43 "parser.mli"
)

val prog :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.block

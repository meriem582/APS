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
  | NUM of (
# 8 "parser.mly"
        int
# 24 "parser.mli"
)
  | IDENT of (
# 9 "parser.mly"
        string
# 29 "parser.mli"
)

val prog :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.cmds

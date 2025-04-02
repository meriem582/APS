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
# 38 "parser.ml"
)
  | IDENT of (
# 9 "parser.mly"
        string
# 43 "parser.ml"
)

open Parsing
let _ = parse_error;;
# 3 "parser.mly"
  open Ast
# 50 "parser.ml"
let yytransl_const = [|
  257 (* LBRA *);
  258 (* RBRA *);
  259 (* LPAR *);
  260 (* RPAR *);
  261 (* SEMCOL *);
  262 (* COL *);
  263 (* COMA *);
  264 (* ARROW *);
  265 (* STAR *);
  266 (* CONST *);
  267 (* FUN *);
  268 (* REC *);
  269 (* ECHO *);
  270 (* IF *);
  271 (* AND *);
  272 (* OR *);
  273 (* BOOL *);
  274 (* INT *);
  275 (* SET *);
  276 (* VAR *);
  277 (* VARA *);
  278 (* ADR *);
  279 (* WHILE *);
  280 (* PROC *);
  281 (* CALL *);
  282 (* VOID *);
  283 (* IFSTAT *);
  284 (* VEC *);
  285 (* ALLOC *);
  286 (* NTH *);
  287 (* LEN *);
  288 (* VSET *);
    0|]

let yytransl_block = [|
  289 (* NUM *);
  290 (* IDENT *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\003\000\003\000\003\000\004\000\004\000\004\000\
\004\000\004\000\004\000\005\000\005\000\005\000\005\000\005\000\
\005\000\006\000\006\000\007\000\008\000\008\000\009\000\009\000\
\009\000\009\000\009\000\015\000\015\000\016\000\016\000\014\000\
\014\000\012\000\012\000\013\000\013\000\010\000\010\000\010\000\
\010\000\010\000\010\000\010\000\010\000\010\000\010\000\010\000\
\011\000\011\000\000\000"

let yylen = "\002\000\
\001\000\003\000\001\000\003\000\003\000\004\000\007\000\008\000\
\003\000\006\000\007\000\001\000\001\000\001\000\005\000\004\000\
\005\000\001\000\003\000\003\000\001\000\003\000\002\000\003\000\
\004\000\003\000\003\000\001\000\005\000\003\000\004\000\001\000\
\003\000\001\000\004\000\001\000\002\000\001\000\001\000\006\000\
\005\000\005\000\004\000\004\000\004\000\004\000\006\000\005\000\
\001\000\002\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\051\000\001\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\038\000\039\000\
\023\000\000\000\028\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\002\000\000\000\000\000\000\000\013\000\012\000\
\014\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\024\000\009\000\026\000\000\000\000\000\000\000\034\000\000\000\
\027\000\000\000\004\000\005\000\000\000\000\000\000\000\006\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\037\000\025\000\000\000\
\000\000\000\000\000\000\000\000\020\000\022\000\044\000\000\000\
\000\000\000\000\045\000\000\000\046\000\000\000\050\000\043\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\016\000\
\019\000\000\000\000\000\000\000\000\000\041\000\042\000\048\000\
\000\000\029\000\000\000\000\000\030\000\010\000\033\000\035\000\
\015\000\000\000\007\000\040\000\047\000\011\000\031\000\008\000"

let yydgoto = "\002\000\
\004\000\005\000\015\000\016\000\070\000\071\000\046\000\047\000\
\017\000\055\000\086\000\064\000\065\000\091\000\028\000\092\000"

let yysindex = "\004\000\
\021\255\000\000\121\255\000\000\000\000\250\254\248\254\016\255\
\255\254\001\255\016\255\252\254\003\255\016\255\036\255\034\255\
\046\255\075\255\023\255\075\255\027\255\094\255\000\000\000\000\
\000\000\025\255\000\000\016\255\075\255\021\255\028\255\052\255\
\026\255\021\255\000\000\121\255\121\255\072\255\000\000\000\000\
\000\000\016\255\075\255\062\255\080\255\061\255\086\255\016\255\
\016\255\016\255\016\255\016\255\016\255\016\255\016\255\255\254\
\000\000\000\000\000\000\090\255\245\254\051\255\000\000\026\255\
\000\000\021\255\000\000\000\000\075\255\085\255\095\255\000\000\
\103\255\027\255\075\255\027\255\016\255\016\255\016\255\016\255\
\102\255\016\255\107\255\016\255\016\255\108\255\016\255\245\254\
\073\255\109\255\112\255\110\255\084\255\000\000\000\000\115\255\
\075\255\075\255\027\255\118\255\000\000\000\000\000\000\016\255\
\125\255\129\255\000\000\131\255\000\000\016\255\000\000\000\000\
\132\255\120\255\133\255\075\255\021\255\245\254\134\255\000\000\
\000\000\138\255\135\255\016\255\139\255\000\000\000\000\000\000\
\143\255\000\000\021\255\075\255\000\000\000\000\000\000\000\000\
\000\000\016\255\000\000\000\000\000\000\000\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\147\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\148\255\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\019\255\
\000\000\000\000\000\000\000\000\000\000\144\255\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\149\255\000\000\000\000\000\000\
\000\000\000\000\000\000\152\255\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\238\255\234\255\000\000\245\255\054\000\000\000\193\255\
\000\000\248\255\070\000\000\000\092\000\169\255\101\000\000\000"

let yytablesize = 157
let yytable = "\025\000\
\114\000\026\000\030\000\019\000\001\000\034\000\042\000\031\000\
\044\000\089\000\100\000\059\000\102\000\067\000\068\000\066\000\
\021\000\058\000\022\000\057\000\036\000\003\000\090\000\036\000\
\063\000\020\000\021\000\018\000\062\000\032\000\135\000\073\000\
\027\000\072\000\029\000\123\000\033\000\035\000\036\000\078\000\
\079\000\080\000\081\000\082\000\083\000\084\000\085\000\095\000\
\023\000\024\000\037\000\021\000\061\000\022\000\056\000\063\000\
\043\000\096\000\023\000\024\000\045\000\060\000\074\000\101\000\
\048\000\049\000\050\000\076\000\103\000\104\000\105\000\106\000\
\093\000\108\000\038\000\110\000\085\000\038\000\113\000\051\000\
\052\000\053\000\054\000\023\000\024\000\075\000\122\000\077\000\
\039\000\040\000\088\000\039\000\040\000\097\000\021\000\125\000\
\022\000\041\000\134\000\069\000\041\000\129\000\098\000\099\000\
\133\000\107\000\115\000\048\000\049\000\050\000\109\000\112\000\
\142\000\117\000\116\000\139\000\118\000\119\000\120\000\124\000\
\143\000\131\000\051\000\052\000\053\000\054\000\023\000\024\000\
\126\000\144\000\006\000\007\000\127\000\008\000\128\000\130\000\
\138\000\136\000\132\000\009\000\010\000\137\000\140\000\011\000\
\012\000\013\000\141\000\014\000\003\000\021\000\121\000\018\000\
\049\000\032\000\111\000\094\000\087\000"

let yycheck = "\008\000\
\088\000\003\001\011\000\012\001\001\000\014\000\018\000\012\001\
\020\000\021\001\074\000\030\000\076\000\036\000\037\000\034\000\
\001\001\029\000\003\001\028\000\002\001\001\001\034\001\005\001\
\033\000\034\001\001\001\034\001\003\001\034\001\118\000\043\000\
\034\001\042\000\034\001\099\000\034\001\002\001\005\001\048\000\
\049\000\050\000\051\000\052\000\053\000\054\000\055\000\066\000\
\033\001\034\001\005\001\001\001\001\001\003\001\030\001\064\000\
\034\001\069\000\033\001\034\001\034\001\034\001\001\001\075\000\
\014\001\015\001\016\001\007\001\077\000\078\000\079\000\080\000\
\022\001\082\000\003\001\084\000\085\000\003\001\087\000\029\001\
\030\001\031\001\032\001\033\001\034\001\006\001\098\000\002\001\
\017\001\018\001\001\001\017\001\018\001\009\001\001\001\104\000\
\003\001\026\001\117\000\028\001\026\001\110\000\008\001\001\001\
\116\000\004\001\034\001\014\001\015\001\016\001\004\001\004\001\
\131\000\002\001\006\001\124\000\007\001\034\001\004\001\002\001\
\132\000\002\001\029\001\030\001\031\001\032\001\033\001\034\001\
\004\001\138\000\010\001\011\001\004\001\013\001\004\001\004\001\
\002\001\004\001\006\001\019\001\020\001\004\001\004\001\023\001\
\024\001\025\001\004\001\027\001\002\001\002\001\097\000\008\001\
\004\001\002\001\085\000\064\000\056\000"

let yynames_const = "\
  LBRA\000\
  RBRA\000\
  LPAR\000\
  RPAR\000\
  SEMCOL\000\
  COL\000\
  COMA\000\
  ARROW\000\
  STAR\000\
  CONST\000\
  FUN\000\
  REC\000\
  ECHO\000\
  IF\000\
  AND\000\
  OR\000\
  BOOL\000\
  INT\000\
  SET\000\
  VAR\000\
  VARA\000\
  ADR\000\
  WHILE\000\
  PROC\000\
  CALL\000\
  VOID\000\
  IFSTAT\000\
  VEC\000\
  ALLOC\000\
  NTH\000\
  LEN\000\
  VSET\000\
  "

let yynames_block = "\
  NUM\000\
  IDENT\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Ast.block) in
    Obj.repr(
# 30 "parser.mly"
           ( _1 )
# 269 "parser.ml"
               : Ast.block))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Ast.cmds) in
    Obj.repr(
# 34 "parser.mly"
                   ( ASTBlock(_2) )
# 276 "parser.ml"
               : Ast.block))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Ast.stat) in
    Obj.repr(
# 38 "parser.mly"
         ( ASTStat(_1) )
# 283 "parser.ml"
               : Ast.cmds))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.def) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.cmds) in
    Obj.repr(
# 39 "parser.mly"
                    ( ASTDef(_1, _3) )
# 291 "parser.ml"
               : Ast.cmds))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.stat) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.cmds) in
    Obj.repr(
# 40 "parser.mly"
                     ( ASTStatCMDS(_1, _3) )
# 299 "parser.ml"
               : Ast.cmds))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Ast.typ) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 44 "parser.mly"
                         ( ASTConst(_2, _3, _4) )
# 308 "parser.ml"
               : Ast.def))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 4 : Ast.typ) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : Ast.arg list) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 45 "parser.mly"
                                      ( ASTFun(_2, _3, _5, _7) )
# 318 "parser.ml"
               : Ast.def))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 5 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 4 : Ast.typ) in
    let _6 = (Parsing.peek_val __caml_parser_env 2 : Ast.arg list) in
    let _8 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 46 "parser.mly"
                                          ( ASTFunRec(_3, _4, _6, _8) )
# 328 "parser.ml"
               : Ast.def))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.typ) in
    Obj.repr(
# 47 "parser.mly"
                  ( ASTVar(_2, _3) )
# 336 "parser.ml"
               : Ast.def))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'argsProc) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Ast.block) in
    Obj.repr(
# 48 "parser.mly"
                                        ( ASTProc(_2, _4, _6) )
# 345 "parser.ml"
               : Ast.def))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : 'argsProc) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : Ast.block) in
    Obj.repr(
# 49 "parser.mly"
                                            ( ASTProcRec(_3, _5, _7) )
# 354 "parser.ml"
               : Ast.def))
; (fun __caml_parser_env ->
    Obj.repr(
# 53 "parser.mly"
        ( BaseType TInt )
# 360 "parser.ml"
               : Ast.typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 54 "parser.mly"
         ( BaseType TBool )
# 366 "parser.ml"
               : Ast.typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 55 "parser.mly"
         ( BaseType TVoid )
# 372 "parser.ml"
               : Ast.typ))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Ast.typ list) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Ast.typ) in
    Obj.repr(
# 56 "parser.mly"
                              ( ASTArrow(_2, _4) )
# 380 "parser.ml"
               : Ast.typ))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Ast.typ) in
    Obj.repr(
# 57 "parser.mly"
                      ( ASTVec(_3) )
# 387 "parser.ml"
               : Ast.typ))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Ast.typ list) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Ast.typ) in
    Obj.repr(
# 58 "parser.mly"
                              ( ASTArrow(_2, _4) )
# 395 "parser.ml"
               : Ast.typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Ast.typ) in
    Obj.repr(
# 62 "parser.mly"
        ( [_1] )
# 402 "parser.ml"
               : Ast.typ list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.typ) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.typ list) in
    Obj.repr(
# 63 "parser.mly"
                   ( _1 :: _3 )
# 410 "parser.ml"
               : Ast.typ list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.typ) in
    Obj.repr(
# 67 "parser.mly"
                  ( Arg(_1, _3) )
# 418 "parser.ml"
               : Ast.arg))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Ast.arg) in
    Obj.repr(
# 71 "parser.mly"
        ( [_1] )
# 425 "parser.ml"
               : Ast.arg list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.arg) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.arg list) in
    Obj.repr(
# 72 "parser.mly"
                  ( _1 :: _3 )
# 433 "parser.ml"
               : Ast.arg list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 76 "parser.mly"
              ( ASTEcho(_2) )
# 440 "parser.ml"
               : Ast.stat))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'lval) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 77 "parser.mly"
                  ( ASTSet(_2, _3) )
# 448 "parser.ml"
               : Ast.stat))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Ast.block) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Ast.block) in
    Obj.repr(
# 78 "parser.mly"
                            ( ASTIfStat(_2, _3, _4) )
# 457 "parser.ml"
               : Ast.stat))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.block) in
    Obj.repr(
# 79 "parser.mly"
                     ( ASTWhile(_2, _3) )
# 465 "parser.ml"
               : Ast.stat))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.exprProc list) in
    Obj.repr(
# 80 "parser.mly"
                         ( ASTCall(_2, _3) )
# 473 "parser.ml"
               : Ast.stat))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 84 "parser.mly"
          ( ASTLvalIdent(_1) )
# 480 "parser.ml"
               : 'lval))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'lval) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Ast.expr) in
    Obj.repr(
# 85 "parser.mly"
                            ( ASTLvalNth(_3, _4) )
# 488 "parser.ml"
               : 'lval))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Ast.typ) in
    Obj.repr(
# 88 "parser.mly"
                  ( ASTArgProc(_1, _3) )
# 496 "parser.ml"
               : 'argProc))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Ast.typ) in
    Obj.repr(
# 89 "parser.mly"
                       (ASTArgProcVar(_2, _4))
# 504 "parser.ml"
               : 'argProc))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'argProc) in
    Obj.repr(
# 93 "parser.mly"
            ( [_1] )
# 511 "parser.ml"
               : 'argsProc))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'argProc) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'argsProc) in
    Obj.repr(
# 94 "parser.mly"
                          ( _1 :: _3 )
# 519 "parser.ml"
               : 'argsProc))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 98 "parser.mly"
         (ASTExpr(_1))
# 526 "parser.ml"
               : Ast.exprProc))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 99 "parser.mly"
                        ( ASTExprProc(_3) )
# 533 "parser.ml"
               : Ast.exprProc))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Ast.exprProc) in
    Obj.repr(
# 103 "parser.mly"
             ( [_1] )
# 540 "parser.ml"
               : Ast.exprProc list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Ast.exprProc) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Ast.exprProc list) in
    Obj.repr(
# 104 "parser.mly"
                       ( _1 :: _2 )
# 548 "parser.ml"
               : Ast.exprProc list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 107 "parser.mly"
        ( ASTNum(_1) )
# 555 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 108 "parser.mly"
          ( ASTId(_1) )
# 562 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Ast.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Ast.expr) in
    Obj.repr(
# 109 "parser.mly"
                                ( ASTIf(_3, _4, _5) )
# 571 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Ast.expr) in
    Obj.repr(
# 110 "parser.mly"
                            ( ASTAnd(_3, _4) )
# 579 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Ast.expr) in
    Obj.repr(
# 111 "parser.mly"
                           ( ASTOr(_3, _4) )
# 587 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Ast.expr list) in
    Obj.repr(
# 112 "parser.mly"
                         ( ASTApp(_2, _3) )
# 595 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : Ast.arg list) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 113 "parser.mly"
                        ( ASTLambda(_2, _4) )
# 603 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Ast.expr) in
    Obj.repr(
# 114 "parser.mly"
                         ( ASTAlloc(_3) )
# 610 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Ast.expr) in
    Obj.repr(
# 115 "parser.mly"
                       ( ASTLen(_3) )
# 617 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Ast.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : Ast.expr) in
    Obj.repr(
# 116 "parser.mly"
                                  ( ASTVset(_3, _4, _5) )
# 626 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : Ast.expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Ast.expr) in
    Obj.repr(
# 117 "parser.mly"
                            ( ASTNth(_3, _4) )
# 634 "parser.ml"
               : Ast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr) in
    Obj.repr(
# 121 "parser.mly"
         ( [_1] )
# 641 "parser.ml"
               : Ast.expr list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Ast.expr) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Ast.expr list) in
    Obj.repr(
# 122 "parser.mly"
               ( _1 :: _2 )
# 649 "parser.ml"
               : Ast.expr list))
(* Entry prog *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let prog (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Ast.block)

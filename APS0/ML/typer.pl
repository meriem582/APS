/*Contexte debut*/ 

/*Γ0(true) = bool
Γ0(false) = bool
Γ0(not) = bool -> bool
Γ0(eq) = int * int -> bool
Γ0(lt) = int * int -> bool
Γ0(add) = int * int -> int
Γ0(sub) = int * int -> int
Γ0(mul) = int * int -> int
Γ0(div) = int * int -> int*/


gamma0 ([
    (true, bool),
    (false, bool),
    (not, arrow(bool, bool)),
    (eq, arrow(int, arrow(int, bool))),
    (lt, arrow(int, arrow(int, bool))),
    (add, arrow(int, arrow(int, int))),
    (sub, arrow(int, arrow(int, int))),
    (mul, arrow(int, arrow(int, int))),
    (div, arrow(int, arrow(int, int)))
]).


/*programme */

is_type_prog(Gamma, prog(C), void) :- is_type_cmds(Gamma, C, void).

/*suite de commandes*/

/*suite de commande avec echo */

is_type_cmds(G, [cmds(C)|CS], void) :- is_type_def(G,C,G1), is_type_cmds(G1,CS,void).
is_type_cmds(_,[],void).
is_type_cmds(G, [C|CS], void) :- is_type_stat(G,C,void), is_type_cmds(G,CS,void).

/*definition d'une constante*/

is_type_def(G, const(X, T, E), G1) :- is_type_expr(G, E, T), G1 = [(X, T)|G].

/*definition d'une fonction*/

rec_type_args([],[]).
rec_type_args([(_,T)|A], [T|TS]) :- rec_type_args(A, TS).

is_type_def(G, fun(X, T, A, E), GI) :- append(A, G, G1), is_type_expr(G1, E, T), rec_type_args(A,TS),GI=[(X, arrow(TS, T))|G].


/*defintion d'une fonction recursive */

is_type_def(G,funRec(X, T, A, E), GI) :- rec_type_args(A,TS) , append(A,G,G1) , G2 = [(X, arrow(TS,T))|G1] , is_type_expr(G2,E,T), GI= [(X, arrow (TS,T))|G]. 

/*defition de ECHO*/
is_type_stat(G,echo(E),void) :- is_type_expr(G,E,int).

/*definition de NUM*/

is_type_expr(_,num(X),int) :- integer(X).

/*definition de ID*/

search(X,[(X,V)|_],V).
search(X,[_|XS],V):- search(X,XS,V).


is_type_expr(G,id(X),T) :- search(X,G,T).


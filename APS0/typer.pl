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

:- discontiguous is_type_def/3.
:- discontiguous is_type_expr/3.


gamma0([
    (true, bool),
    (false, bool),
    (not, arrow([bool], bool)),
    (eq, arrow([int, int], bool)),
    (lt, arrow([int, int], bool)),
    (add, arrow([int, int], int)),
    (sub, arrow([int, int], int)),
    (mul, arrow([int, int], int)),
    (div, arrow([int, int], int))
]).



/*Programme */
/* is_type_prog est le jugement de typage de programme */
/* is_type_cmds est le jugement de typage de suite de commandes, il est définie juste après */
/* le principe est que si CS passe le jugement de typage de CMDS "est jugé comme étant suite de commandes dans le context G0" alors [CS] passe le jugement de typage de programme "programme bien typé ✅"  */
is_type_prog(G0, prog(CS), void) :- is_type_cmds(G0, CS, void).



/*suite de commandes*/
/* les DEFS */
/* D est la définition à jugé si elle satisfait la jugement is_type_def définie juste après*/
/* G est le context courant*/ 
/* G1 c'est le nouveau context "gamma prim" */
is_type_cmds(G, [cmds(D)|CS], void) :- is_type_def(G,D,G1), is_type_cmds(G1,CS,void).

/* END */
/* passer S au jugement de typage is_type_stat */
is_type_cmds(G, [S|CS], void) :- is_type_stat(G,S,void), is_type_cmds(G,CS,void).
/* [] signifie que y a pas Commandes à traiter "END" */
is_type_cmds(_,[],void).

/* jugement du typage de definitions*/

/*definition d'une constante*/
/* is_type_expr est le jugement de typage d'expression, il est définie plus tard dans le code */

is_type_def(G, const(X, T, E), [(X,T)|G]) :- is_type_expr(G, E, T).

/*definition d'une fonction*/

rec_type_args([],[]).
rec_type_args([(_,T)|ARGS], [T|TI]) :- rec_type_args(ARGS, TI).

is_type_def(G, fun(X, T, ARGS, E), GI) :- append(ARGS, G, G1), is_type_expr(G1, E, T), rec_type_args(ARGS,TI),GI=[(X, arrow(TI, T))|G].


/*defintion d'une fonction recursive */

is_type_def(G,funRec(X,T,ARGS,E),GI):-
	rec_type_args(ARGS,TI),
	append(ARGS,G,G1),
    G2 = [(X,arrow(TI,T))|G1],
	is_type_expr(G2,E,T),
	GI=[(X,arrow(TI,T))|G]. 

/*Introduction*/
/* jugement de typage de stat "ECHO" */
is_type_stat(G,echo(E),void) :- is_type_expr(G,E,int).

/*Expression*/
/* jugement de typage d'expression */

/* num */
is_type_expr(_,num(N),int) :- integer(N).

search(X,[(X,V)|_],V).
search(X,[_|XS],V):- search(X,XS,V).

/*ID*/
is_type_expr(G,id(X),T) :- search(X,G,T).

/* IF */
/* pour que le IF sois une expression typable faut que le E1 sois une condition (de résultat TRUE ou False "du sens que c'est un bool") et les deux expression "le conséquant et l'alternant" sois de même type */
is_type_expr(G, if(E1,E2,E3), T) :- is_type_expr(G, E1, bool), is_type_expr(G, E2, T), is_type_expr(G, E3, T).

/* AND */
/* faut que les deux operands sois des boolean */
is_type_expr(G, and(E1, E2), bool) :- is_type_expr(G,E1,bool), is_type_expr(G,E2,bool).

/* OR */
/* idem que AND*/
is_type_expr(G, or(E1, E2), bool) :- is_type_expr(G,E1,bool) , is_type_expr(G,E2,bool).

/* APP */

/* on passe tout les EI au verificateur EI pour verifier si chacun des EI passe le jugement de typage d'expression dans le context courant */
verifieEI(_,[], []).
verifieEI(G,[E|EI],[T|TI]) :- is_type_expr(G,E,T), verifieEI(G,EI,TI).


is_type_expr(G,app(E, EI), T) :- is_type_expr(G,E,arrow(TI,T)), verifieEI(G,EI,TI).

/* ABS */

is_type_expr(G, lambda(ARGS,E), arrow(TI,T)) :- append(ARGS,G,GI),rec_type_args(ARGS,TI), is_type_expr(GI,E,T).

main_stdin :-
    read(user_input, T),
    gamma0(L),
    ( is_type_prog(L, T, R) ->
        print(R)
    ; 
        print('type_error')
    ).

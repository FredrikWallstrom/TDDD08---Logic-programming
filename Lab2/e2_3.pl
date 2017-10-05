% Exercise 2.3

% num(N).
% N is a number if N is an integer of a floating point number.
num(N) :- number(N).

exists([[I, _]|_S0], I).
exists([[_I1, _]|S0], I) :-
	exists(S0, I).

% execute(S0, P, Sn).
% If P is a program and S0 is an initial binding environment (represented as [[Id1, Num1], [Id2, Num2], ...]).
% Than Sn is the final binding environment that the execution of P results in.
execute(_S0, skip).
execute(S0, set(id(I), E), Sn) :-
	(exists(S0, I),
	 arith_expr(S0, E, Replacement),
	 assign(S0, Replacement, I, Sn)) ;
	(\+ exists(S0, I),
	 arith_expr(S0, E, Replacement),
	 Sn = [[I, Replacement]|S0]).
execute(S0, if(If, Then, Else), Sn) :-
	(bool_expr(S0, If, Res), Res = 1, execute(S0, Then, Sn)) ;
	(bool_expr(S0, If, Res), Res = 0, execute(S0, Else, Sn)).
execute(S0, while(If, Then), Sn) :-
	bool_expr(S0, If, Res),
	(Res = 1, execute(S0, Then, SubRes), execute(SubRes, while(If, Then), Sn)) ;
	(Res = 0, Sn = S0).
execute(S0, seq(C1, C2), Sn) :-
	execute(S0, C1, Res),
	execute(Res, C2, Sn).

% expr(S0, E).
% If S0 is the initial binding environment,
% than E is the boolean expression.
bool_expr(S0, X < Y, Z) :- 
	(arith_expr(S0, X, Z1),
	 arith_expr(S0, Y, Z2),
	 Z1 < Z2,
	 Z is 1) ;
	(arith_expr(S0, X, Z1),
	 arith_expr(S0, Y, Z2),
	 Z1 >= Z2,
	 Z is 0).
bool_expr(S0, X =< Y, Z) :-
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	(Z1 =< Z2, Z is 1) ;
	(Z1 > Z2, Z is 0).
bool_expr(S0, X == Y, Z) :-
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	(Z1 == Z2, Z is 1) ;
	(Z1 \== Z2, Z is 0).
bool_expr(S0, X > Y, Z) :-
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	(Z1 > Z2, Z is 1) ;
	(Z1 =< Z2, Z is 0).
bool_expr(S0, X >= Y, Z) :-
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	(Z1 >= Z2, Z is 1) ;
	(Z1 < Z2, Z is 0).

% arith_expr(S0, A, Z).
% If S0 is the initial binding environment and A is an arithmetic expression.
% Than Z is the result of the arithmetic operation.
arith_expr(_S0, num(E), E) :- 
	num(E).
arith_expr(S0, id(I), Z) :-
	member([I,Z], S0).
arith_expr(S0, X+Y, Z) :-
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	Z is Z1+Z2.
arith_expr(S0, X-Y, Z) :-
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	Z is Z1-Z2.
arith_expr(S0, X*Y, Z) :-
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	Z is Z1*Z2.
arith_expr(S0, X/Y, Z) :-
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	Z is Z1/Z2.

% assign(S0, Replacement, I, Sn).
% If S0 is the initial binding environment, I is an identifier and Replacement is a number.
% Than Sn is a copy of S0 except that I:s number is replaced by Replacement.
assign([], _, _, []).
assign([[I, _]|S0], Replacement, I, [[I, Replacement]|Sn]) :-
	assign(S0, Replacement, I, Sn).
assign([[I1, X1]|S0], Replacement, I, [[I1, X1]|Sn]) :-
	dif(I, I1),
	assign(S0, Replacement, I, Sn).


/* Example queries for the program are listed below.

| ?- arith_expr([[x,1],[y,3]], id(x), Z).
Z = 1 ? ;
no
| ?- arith_expr([[x,1],[y,3]], num(3), Z).
Z = 3 ? ;
no
| ?- execute([[x,3],[y,3]], skip).
yes
| ?- execute([[x,1],[y,3]], set(id(x), num(3)), Sn).
Sn = [[x,3],[y,3]] ? ;
no
| ?- execute([[x,3]], set(id(y), num(1)),Sn).
Sn = [[y,1],[x,3]] ? ;
no
| ?- execute([[x,1],[y,3]], if(id(x) < num(3), set(id(x), num(3)), set(id(x), num(0))), Sn).
Sn = [[y,3],[x,3]] ? ;
no
| ?- execute([[x,3],[y,3]], if(id(x) < num(3), set(id(x), num(3)), set(id(x), num(0))), Sn).
Sn = [[y,3],[x,0]] ? ;
no
| ?- execute([[x,3]], seq(set(id(y),num(1)), while(id(x) > num(1), seq(set(id(y), id(y) * id(x)), set(id(x), id(x) - num(1))))), Sn).
Sn = [[y,6],[x,1]] ? ;
no

*/


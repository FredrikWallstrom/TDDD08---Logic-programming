% Exercise 2.3

id(I).
num(N) :- number(N).

execute(S0, skip, Sn).
execute(S0, set(id(I), E), Sn) :-
	e(S0, E, Replacement), 
	assign(S0, Replacement, I, Sn).
execute(S0, if(If, Then, Else), Sn) :-
	b(S0, If),
	execute(S0, Then, Sn).
execute(S0, if(If, Then, Else), Sn) :-
	b_false(S0, If),
	execute(S0, Else, Sn).	
execute(S0, while(If, Then), Sn) :-
	b_false(S0, If),
	Sn = S0.
execute(S0, while(If, Then), Sn) :-
	b(S0, If),
	execute(S0, Then, Res),
	execute(Res, while(If, Then), Sn).
execute(S0, seq(C1, C2), Sn) :-
	execute(S0, C1, Res),
	execute(Res, C2, Sn).

b(S0, (X < Y)) :- 
	e(S0, X, Z1),
	e(S0, Y, Z2),
	Z1 < Z2.
b(S0, (X =< Y)) :-
	e(S0, X, Z1),
	e(S0, Y, Z2),
	Z1 =< Z2.
b(S0, (X == Y)) :-
	e(S0, X, Z1),
	e(S0, Y, Z2),
	Z1 == Z2.
b(S0, (X > Y)) :-
	e(S0, X, Z1),
	e(S0, Y, Z2),
	Z1 > Z2.
b(S0, (X >= Y)) :-
	e(S0, X, Z1),
	e(S0, Y, Z2),
	Z1 >= Z2.

b_false(S0, (X < Y)) :- 
	e(S0, X, Z1),
	e(S0, Y, Z2),
	Z1 >= Z2.
b_false(S0, (X =< Y)) :-
	e(S0, X, Z1),
	e(S0, Y, Z2),
	Z1 > Z2.
b_false(S0, (X == Y)) :-
	e(S0, X, Z1),
	e(S0, Y, Z2),
	Z1 \== Z2.
b_false(S0, (X > Y)) :-
	e(S0, X, Z1),
	e(S0, Y, Z2),
	Z1 =< Z2.
b_false(S0, (X >= Y)) :-
	e(S0, X, Z1),
	e(S0, Y, Z2),
	Z1 < Z2.


e(S0, num(E), E) :- 
	num(E).
e(S0, id(I), Z) :-
	member([I,Z], S0).
e(S0, X+Y, Z) :-
	e(S0, X, Z1),
	e(S0, Y, Z2),
	Z is Z1+Z2.
e(S0, X-Y, Z) :-
	e(S0, X, Z1),
	e(S0, Y, Z2),
	Z is Z1-Z2.
e(S0, X*Y, Z) :-
	e(S0, X, Z1),
	e(S0, Y, Z2),
	Z is Z1*Z2.
e(S0, X/Y, Z) :-
	e(S0, X, Z1),
	e(S0, Y, Z2),
	Z is Z1/Z2.


assign([], X, I, [[I, X]]).
assign([[I, X1]|Sn], X, I, S0) :-
	assign(Sn, X, I, S0).
assign([[I1, X1]|Sn], X, I, [[I1, X1]|S0]) :-
	dif(I, I1),
	assign(Sn, X, I, S0).


/* Example queries for the program are listed below.

| ?- e([[x,1],[y,3]], id(x), Z).
Z = 1 ? ;
no
| ?- e([[x,1],[y,3]], num(3), Z).
Z = 3 ? ;
no
| ?- execute([[x,3],[y,3]], skip, Sn).
yes
| ?- execute([[x,1],[y,3]], set(id(x), num(3)), Sn).
Sn = [[x,3],[y,3]] ? ;
no
| ?- execute([[x,3]], set(id(y), num(1)),Sn).
Sn = [[x,3],[y,1]] ? ;
no
| ?- execute([[x,1],[y,3]], if(id(x) < num(3), set(id(x), num(3)), set(id(x), num(0))), Sn).
Sn = [[x,3],[y,3]] ? ;
no
| ?- execute([[x,3],[y,3]], if(id(x) < num(3), set(id(x), num(3)), set(id(x), num(0))), Sn).
Sn = [[x,0],[y,3]] ? ;
no
| ?- execute([[x,3]], seq(set(id(y),num(1)), while(id(x) > num(1), seq(set(id(y), id(y) * id(x)), set(id(x), id(x) - num(1))))), Sn).
Sn = [[y,6],[x,1]] ? ;
no
*/


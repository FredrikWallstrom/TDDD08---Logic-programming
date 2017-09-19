% Exercise 3.1

run(In, String, Out) :-
	scan(String, Tokens),
	parse(Tokens, AbstStx).

parse(Tokens, AbstStx) :-
	pgm(AbstStx, Tokens, []).


pgm(X) --> cmd(X).
pgm(seq(X,Y)) --> cmd(X), [;], pgm(Y).

cmd(skip) --> [skip].
cmd(set(X, Y)) --> [X], [:=], expr(Y).
cmd(if(Bool, Pgm1, Pgm2)) --> [if], bool(Bool), [then], pgm(Pgm1), [else], pgm(Pgm2), [fi].
cmd(while(Bool, Pgm)) --> [while], bool(Bool), [do], pgm(Pgm), [od].

bool(X < Y) --> expr(X) < expr(Y).
bool(X =< Y) --> expr(X) =< expr(Y).
bool(X == Y) --> expr(X) == expr(Y).
bool(X > Y) --> expr(X) > expr(Y).
bool(X >= Y) --> expr(X) >= expr(Y).

expr(X * Y) --> factor(X) * expr(Y).
expr(X) --> factor(X).

factor(X + Y) --> term(X) + factor(Y).
factor(X) --> term(X).

term(X) --> [X].


	

% Scanner for assignment 3
% TDDD08 Logic Programming
%
% top predicate:
% scan(+String, -Tokens) 
%
% try: scan("x:=3; y:=1; while x>1 do y := y*x; x := x-1 od",Tokens).
%
% NOTE: strings are lists of ASCII codes, i.e.
% "Prolog" = [80,114,111,108,111,103]

scan([],[]).
scan([C|Cs],[';'|Ts]) :-
	semicolon(C),!,
	scan(Cs,Ts).
scan([C|Cs],Ts) :-
	space(C),!,
	scan(Cs,Ts).
scan([C|Cs],[num(T)|Ts]) :-
	digit(C),!,
	scan_number(Cs,Cs1,CNum),
	name(T,[C|CNum]),
	scan(Cs1,Ts).
scan([C1,C2|Cs],[T|Ts]) :-
	name(T,[C1,C2]),
	operator(T),!,
	scan(Cs,Ts).
scan([C|Cs],[T|Ts]):-
	name(T,[C]),
	operator(T),!,
	scan(Cs,Ts).
scan([C|Cs],[T|Ts]) :-
	letter(C),
	scan_key_or_id(Cs,Cs1,CWord),
	name(Word,[C|CWord]),
	classify(Word,T),
	scan(Cs1,Ts).

% scaning a number
% scan_number(+In, -Out, -Num)
% Num is a string of digits from front of In,
% Out is the remaining string

scan_number([C|Cs],Cs1,[C|CN]) :-
	digit(C),!,
	scan_number(Cs,Cs1,CN).
scan_number(Cs,Cs,[]).

% scaning a keyword or an identifier
% scan_key_or_id(+In, -Out, -Word)
% Word is a string from front of In,
% Out is the remaining string

scan_key_or_id([C|Cs],Cs1,[C|CW]) :-
	(letter(C)
	 ;
	 digit(C)
	),!,
	scan_key_or_id(Cs,Cs1,CW).
scan_key_or_id(Cs,Cs,[]).

% distinguishing keywords from identifiers

classify(W,T) :-
	keyword(W),!,
	T = W.
classify(W,id(W)).


digit(C) :-
	C >= "0", C =< "9".


letter(C) :-
	C >= "a", C =< "z"
	;
	C >= "A", C =< "Z".


semicolon(59).


operator('*').
operator('+').
operator('/').
operator('-').
operator('>').
operator('<').
operator('=').
operator('=<').
operator('>=').
operator(':=').


space(32).


keyword(skip).
keyword(if).
keyword(then).
keyword(else).
keyword(fi).
keyword(while).
keyword(do).
keyword(od).
keyword(true).
keyword(false).


% Exercise 2.3


% num(N).
% N is a number if N is an integer of a floating point number.
num(N) :- number(N).

% execute(S0, P, Sn).
% If P is a program and S0 is an initial binding environment (represented as [[Id1, Num1], [Id2, Num2], ...]).
% Than Sn is the final binding environment that the execution of P results in.
execute(S0, skip, Sn).
execute(S0, set(id(I), E), Sn) :-
	arith_expr(S0, E, Replacement), 
	assign(S0, Replacement, I, Sn).
execute(S0, if(If, Then, Else), Sn) :-
	bool_expr(S0, If),
	execute(S0, Then, Sn).
execute(S0, if(If, Then, Else), Sn) :-
	bool_expr_false(S0, If),
	execute(S0, Else, Sn).
execute(S0, while(If, Then), Sn) :-
	bool_expr(S0, If),
	execute(S0, Then, Res),
	execute(Res, while(If, Then), Sn).
execute(S0, while(If, Then), Sn) :-
	bool_expr_false(S0, If),
	Sn = S0.
execute(S0, seq(C1, C2), Sn) :-
	execute(S0, C1, Res),
	execute(Res, C2, Sn).

% expr(S0, E).
% If S0 is the initial binding environment,
% than E is the boolean expression.
bool_expr(S0, X < Y) :- 
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	Z1 < Z2.
bool_expr(S0, X =< Y) :-
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	Z1 =< Z2.
bool_expr(S0, X == Y) :-
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	Z1 == Z2.
bool_expr(S0, X > Y) :-
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	Z1 > Z2.
bool_expr(S0, X >= Y) :-
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	Z1 >= Z2.

% expr_false(S0, E).
% If S0 is the initial binding environment,
% than E is the false boolean expression.
bool_expr_false(S0, X < Y) :- 
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	Z1 >= Z2.
bool_expr_false(S0, X =< Y) :-
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	Z1 > Z2.
bool_expr_false(S0, X == Y) :-
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	Z1 \== Z2.
bool_expr_false(S0, X > Y) :-
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	Z1 =< Z2.
bool_expr_false(S0, X >= Y) :-
	arith_expr(S0, X, Z1),
	arith_expr(S0, Y, Z2),
	Z1 < Z2.

% arith_expr(S0, A, Z).
% If S0 is the initial binding environment and A is an arithmetic expression.
% Than Z is the result of the arithmetic operation.
arith_expr(S0, num(E), E) :- 
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
assign([], Replacement, I, [[I, Replacement]]).
assign([[I, X1]|S0], Replacement, I, Sn) :-
	assign(S0, Replacement, I, Sn).
assign([[I1, X1]|S0], Replacement, I, [[I1, X1]|Sn]) :-
	dif(I, I1),
	assign(S0, Replacement, I, Sn).
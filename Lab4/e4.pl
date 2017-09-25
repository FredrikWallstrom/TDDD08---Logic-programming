init(state(3,3,0,0)).
goal(state(0,0,3,3)).

add(X,Y, state(R)) :-
	R is X+Y.
% Move two cannibals
action(state(CL, ML, CR, MR), state(CL1, ML, CR1, MR)) :-
	Tmp1 is CL - 2,
	Tmp1 >= 0,
	Tmp1 =< ML,
	Tmp2 is CR + 2,
	Tmp2 =< 3,
	(Tmp2 =< MR ; MR == 0),
	CL1 is CL - 2,
	CR1 is CR + 2.

% Move one cannibal
action(state(CL, ML, CR, MR), state(CL1, ML, CR1, MR)) :-
	Tmp1 is CL - 1,
	Tmp1 >= 0,
	Tmp1 =< ML,
	Tmp2 is CR + 1,
	Tmp2 =< 3,
	(Tmp2 =< MR ; MR == 0),
	CL1 is CL - 1,
	CR1 is CR + 1.

% Move two missionary
action(state(CL, ML, CR, MR), state(CL, ML1, CR, MR1)) :-
	ML1 is ML - 2,
	MR1 is MR + 2,
	ML1 >= 0,
	MR1 =< 3,
	ML1 >= CL,
	MR1 >= CR.

% Move one missionary
action(state(CL, ML, CR, MR), state(CL, ML1, CR, MR1)) :-
	ML1 is ML - 1,
	MR1 is MR + 1,
	ML1 >= 0,
	MR1 =< 3,
	ML1 >= CL,
	MR1 >= CR.

% Depth-first search
df_search(Path) :-
	init(S0),
	df_search([S0], Path).

df_search([S|Visited], [S|Visited]) :-
	goal(S).


df_search([S1|Visited], Path) :-
	action(S1, S2),
	nonmember(S2, [S1|Visited]),
	df_search([S2, S1|Visited], Path).
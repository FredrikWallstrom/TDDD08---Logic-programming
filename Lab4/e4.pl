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
	Tmp1 is ML - 2,
	Tmp2 is MR + 2,
	Tmp1 >= 0,
	Tmp2 =< 3,
	Tmp1 >= CL,
	Tmp2 >= CR,
	ML1 is ML - 2,
	MR1 is MR + 2.

% Move one missionary
action(state(CL, ML, CR, MR), state(CL, ML1, CR, MR1)) :-
	Tmp1 is ML - 1,
	Tmp2 is MR + 1,
	Tmp1 >= 0,
	Tmp2 =< 3,
	Tmp1 >= CL,
	Tmp2 >= CR,
	ML1 is ML - 1,
	MR1 is MR + 1.

% Move one missionary, one cannibal
action(state(CL, ML, CR, MR), state(CL1, ML1, CR1, MR1)) :-
	Tmp1 is ML - 1,
	Tmp2 is MR + 1,
	Tmp3 is CL - 1,
	Tmp4 is CR + 1,
	Tmp3 >= 0,
	Tmp1 >= 0,
	Tmp2 =< 3,
	Tmp4 =< 3,
	Tmp1 >= Tmp3,
	Tmp2 >= Tmp4,
	ML1 is ML - 1,
	MR1 is MR + 1,
	CL1 is CL - 1,
	CR1 is CR + 1.

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


% Breath-first search
bf_search(Path) :-
	init(S0),
	bf_search([[S0]], Path).
bf_search([[S|Path]|_], [S|Path]) :-
	goal(S).
bf_search([[S1|Path]|Partials], FinalPath) :-
	findall(S2, action(S1, S2), NewStates),
	expand([S1|Path], NewStates1, NewPaths),
	append(Partials, NewPaths, NewPartials),
	bf_search(NewPartials, FinalPath).
expand(L1, L2, L3) :-
	findall([X|L1], member(X,L2), L3).







remove_explored_states([], _, []).
remove_explored_states([X|L], Partials, N1) :-
	r(X, Partials, N2),
	remove_explored_states(L, Partials, N2).
r(_, [], []).
r(X, [Y|L2], [X|L3]) :-	      
	dif(X,Y),
	r(X, L2, L3).
r(X, [X|L2], L3) :-
	r(X, L2, L3).
	
	
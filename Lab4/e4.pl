% Exercise 4
% Fredrik Wallström

% Set prolog flag to print the whole result and not just a part of a list.
% set_prolog_flag(toplevel_print_options, [quoted(true), portrayed(true), max_depth(0)]).

% Initialize the start and the goal state of the problem.
% One state is represented as:
% state(#CannibalsLeft, #MissionariesLeft, #CannibalsRight, #MissionariesRight, Boatside).
init(state(3, 3, 0, 0, left)).
goal(state(0, 0, 3, 3, right)).

%------------------------ PROBLEM ------------------------%

% Move two cannibals, left to right.
action(state(CL, ML, CR, MR, left), state(CL1, ML, CR1, MR, right)) :-
	CL1 is CL - 2,
	CR1 is CR + 2,
	state_allowable(CL1, ML, CR1, MR).

% Move two missionaries, left to right.
action(state(CL, ML, CR, MR, left), state(CL, ML1, CR, MR1, right)) :-
	ML1 is ML - 2,
	MR1 is MR + 2,
	state_allowable(CL, ML1, CR, MR1).

% Move one missionary and one cannibal, left to right.
action(state(CL, ML, CR, MR, left), state(CL1, ML1, CR1, CR1, right)) :-
	ML1 is ML - 1,
	MR1 is MR + 1,
	CL1 is CL - 1,
	CR1 is CR + 1,
	state_allowable(CL1, ML1, CR1, MR1).

% Move one cannibal, left to right.
action(state(CL, ML, CR, MR, left), state(CL1, ML, CR1, MR, right)) :-
	CL1 is CL - 1,
	CR1 is CR + 1,
	state_allowable(CL1, ML, CR1, MR).

% Move one missionary , left to right.
action(state(CL, ML, CR, MR, left), state(CL, ML1, CR, MR1, right)) :-
	ML1 is ML - 1,
	MR1 is MR + 1,
	state_allowable(CL, ML1, CR, MR1).

% Move two cannibals, right to left.
action(state(CL, ML, CR, MR, right), state(CL1, ML, CR1, MR, left)) :-
	CL1 is CL + 2,
	CR1 is CR - 2,
	state_allowable(CL1, ML, CR1, MR).

% Move two missionaries, right to left.
action(state(CL, ML, CR, MR, right), state(CL, ML1, CR, MR1, left)) :-
	ML1 is ML + 2,
	MR1 is MR - 2,
	state_allowable(CL, ML1, CR, MR1).

% Move one missionary and one cannibal, right to left.
action(state(CL, ML, CR, MR, right), state(CL1, ML1, CR1, MR1, left)) :-
	ML1 is ML + 1,
	MR1 is MR - 1,
	CL1 is CL + 1,
	CR1 is CR - 1,
	state_allowable(CL1, ML1, CR1, MR1).

% Move one cannibal, right to left.
action(state(CL, ML, CR, MR, right), state(CL1, ML, CR1, MR, left)) :-
	CL1 is CL + 1,
	CR1 is CR - 1,
	state_allowable(CL1, ML, CR1, MR).

% Move one missionary, right to left.
action(state(CL, ML, CR, MR, right), state(CL, ML1, CR, MR1, left)) :-
	ML1 is ML + 1,
	MR1 is MR - 1,
	state_allowable(CL, ML1,  CR, MR1).

% Check if the current state is OK!
% A state is OK, if missionaries is greater than the cannibals on both sides,
% or if there is none missionary on some side of the river.
state_allowable(CL, ML, CR, MR) :-
	CL >= 0,
	ML >= 0,
	CR >= 0,
	MR >= 0,
	(ML >= CL ; !, ML = 0),
	(MR >= CR ; !, MR = 0).


%------------------------ DEPTH-FIRST SEARCH ------------------------%

% Path is a path from start to goal.
df_search(Path) :-
	init(S0),
	df_search([S0], UnreversedPath),
	reverse_list(UnreversedPath, Path, []).
df_search([S|Visited], [S|Visited]) :-
	goal(S).
df_search([S1|Visited], Path) :-
	action(S1, S2),
	nonmember(S2, [S1|Visited]),
	df_search([S2, S1|Visited], Path).

%------------------------ BREADTH-FIRST SEARCH ------------------------%

% Path is a path from start to goal.
bf_search(Path) :-
	init(S0),
	bf_search([[S0]], [], UnreversedPath),
	reverse_list(UnreversedPath, Path, []).

% bf_search(Paths, FinalPath).
% Paths is a list of candidate branches, FinalPath is the solution.
bf_search([[S|Path]|_], _, [S|Path]) :-
	goal(S).
bf_search([[S1|Path]|Partials], Visited, FinalPath) :-
	append([S1], Visited, NewVisited),
	findall(S2, action(S1, S2), NewStates),
	remove_visited(NewStates, NewVisited, NewFilteredStates),
	expand([S1|Path], NewFilteredStates, NewPaths),
	append(Partials, NewPaths, NewPartials),
	bf_search(NewPartials, NewVisited, FinalPath).

% expand(L1, L2, L3).
% L3 is the expanded list given by expand L1 with L2.
expand(L1, L2, L3) :-
	findall([X|L1], member(X,L2), L3).

% Remove visited nodes in breadth first search.
remove_visited(NewStates, NewVisited, NewFilteredStates) :-
	subtract(NewStates, NewVisited, NewFilteredStates).

% subtract(L1, L2, L3).
% If L1 and L2 are lists, than L3 is the set difference: 
% L1\L2 (i.e, L1 minus L2).
subtract([], _, []).
subtract([H|T], L2, L3) :-
	member(H, L2),
	!,
	subtract(T, L2, L3).
subtract([H|T], L2, [H|T1]) :-
	subtract(T, L2, T1).

% reverse_list(L1, L2, SoFar).
% If L1 is a list than L2 is the reversed list of L1.
reverse_list([], Res, Res).
reverse_list([H|T], Res, L) :-
	reverse_list(T, Res, [H|L]).

%------------------------ RUNNING EXAMPLES ------------------------%
/*

%%%%%%%%%% P in the examples can be explained as following.
%%%%%%%%%% The first element will represent the initialize state of the
%%%%%%%%%% cannibals and the missionaries, 3 cannibals at left side as first
%%%%%%%%%% element, 3 missionaries at left side as second element,
%%%%%%%%%% 0 cannibals at right side as third element, 0 missionaries at
%%%%%%%%%% right side as fourth element and the boat is at the left side.
%%%%%%%%%% The second element in P is the state that we can go from the
%%%%%%%%%% first state, and so on...
%%%%%%%%%% We got four ways we can transport the cannibals and missionaries
%%%%%%%%%% over to the right side without having the cannibals eating the
%%%%%%%%%% missionaries.

  
| ?- set_prolog_flag(toplevel_print_options, [quoted(true), portrayed(true), max_depth(0)]).
yes
| ?- df_search(P).
P = [state(3,3,0,0,left),state(1,3,2,0,right),state(2,3,1,0,left),state(0,3,3,0,right),state(1,3,2,0,left),state(1,1,2,2,right),state(2,2,1,1,left),state(2,0,1,3,right),state(3,0,0,3,left),state(1,0,2,3,right),state(2,0,1,3,left),state(0,0,3,3,right)] ? ;
P = [state(3,3,0,0,left),state(1,3,2,0,right),state(2,3,1,0,left),state(0,3,3,0,right),state(1,3,2,0,left),state(1,1,2,2,right),state(2,2,1,1,left),state(2,0,1,3,right),state(3,0,0,3,left),state(1,0,2,3,right),state(1,1,2,2,left),state(0,0,3,3,right)] ? ;
P = [state(3,3,0,0,left),state(2,2,1,1,right),state(2,3,1,0,left),state(0,3,3,0,right),state(1,3,2,0,left),state(1,1,2,2,right),state(2,2,1,1,left),state(2,0,1,3,right),state(3,0,0,3,left),state(1,0,2,3,right),state(2,0,1,3,left),state(0,0,3,3,right)] ? ;
P = [state(3,3,0,0,left),state(2,2,1,1,right),state(2,3,1,0,left),state(0,3,3,0,right),state(1,3,2,0,left),state(1,1,2,2,right),state(2,2,1,1,left),state(2,0,1,3,right),state(3,0,0,3,left),state(1,0,2,3,right),state(1,1,2,2,left),state(0,0,3,3,right)] ? ;
no


| ?- bf_search(P).
P = [state(3,3,0,0,left),state(1,3,2,0,right),state(2,3,1,0,left),state(0,3,3,0,right),state(1,3,2,0,left),state(1,1,2,2,right),state(2,2,1,1,left),state(2,0,1,3,right),state(3,0,0,3,left),state(1,0,2,3,right),state(2,0,1,3,left),state(0,0,3,3,right)] ? ;
P = [state(3,3,0,0,left),state(1,3,2,0,right),state(2,3,1,0,left),state(0,3,3,0,right),state(1,3,2,0,left),state(1,1,2,2,right),state(2,2,1,1,left),state(2,0,1,3,right),state(3,0,0,3,left),state(1,0,2,3,right),state(1,1,2,2,left),state(0,0,3,3,right)] ? ;
P = [state(3,3,0,0,left),state(2,2,1,1,right),state(2,3,1,0,left),state(0,3,3,0,right),state(1,3,2,0,left),state(1,1,2,2,right),state(2,2,1,1,left),state(2,0,1,3,right),state(3,0,0,3,left),state(1,0,2,3,right),state(2,0,1,3,left),state(0,0,3,3,right)] ? ;
P = [state(3,3,0,0,left),state(2,2,1,1,right),state(2,3,1,0,left),state(0,3,3,0,right),state(1,3,2,0,left),state(1,1,2,2,right),state(2,2,1,1,left),state(2,0,1,3,right),state(3,0,0,3,left),state(1,0,2,3,right),state(1,1,2,2,left),state(0,0,3,3,right)] ? ;
no




*/

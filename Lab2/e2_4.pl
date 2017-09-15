% Exercise 2.4

% sorted(L).
% L is sorted if the elements is in ascending order.
sorted([X1, X2]) :-
	X1@<X2.
sorted([X1, X2 | L]) :-
	X1@<X2,
	sorted([X2 | L]).

% min_in_list(L, Min).
% Min is the smallest number in the list L.
min_in_list([Min], Min).
min_in_list([X, Y | L], Min) :-
	X @< Y,
	min_in_list([X | L], Min).
min_in_list([X, Y | L], Min) :-
	X @>= Y,
	min_in_list([Y | L], Min).

% delete_from_list(L, E, L1).
% L1 is the same list as L but without the elements E.
delete_from_list([], _, []).
delete_from_list([E|L], E, L1) :-
	delete_from_list(L, E, L1).
delete_from_list([H|L], E, [H|L1]) :-
	E \= H,
	delete_from_list(L, E, L1).

% ssort(L, LS).
% LS is the sorted list of L.
ssort([], []).
ssort(L, [Min|LS]) :-
	min_in_list(L, Min),
	delete_from_list(L, Min, L1),
	ssort(L1, LS).

% union(S1, S2, Res).
% Res is the result you get if you take the union of the sets S1 and S2.
union(S1, S2, Res) :-
	append(S1, S2, Unsorted),
	ssort(Unsorted,Res).

% intersection(S)
% Res is the intersection of the sets S1 and S2.
intersection([], _, []).
intersection([H1|S1], S2, Res) :-
	\+ member(H1, S2),
	intersection(S1, S2, Res).
intersection([H1|S1], S2, [H1|Res]) :-
	member(H1, S2),
	intersection(S1, S2, Res).

% powerset(S, Res).
% Res is the powerset of the set S.
powerset(S, Res) :-
	ssort(S, Sorted),
	findall(X, append(X, _, Sorted), Res).

/* Example queries for the program are listed below.

| ?- union([a,b,c], [a,b,c,d,e], Res).
Res = [a,b,c,d,e] ? ;
no
| ?- intersection([a,b,c], [a,b,c,d,e,f,g,h], Res).
Res = [a,b,c] ? ;
no
| ?- powerset([a,b,c,d,e], Res).
Res = [[],[a],[a,b],[a,b,c],[a,b,c,d],[a,b,c,d,e]] ? ;
no

*/





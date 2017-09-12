% Exercise 2.1

% sorted(L).
% L is sorted if the elements is in ascending order.
sorted([X1, X2]) :-
	X1<X2.
sorted([X1, X2 | L]) :-
	X1<X2,
	sorted([X2 | L]).

% min_in_list(L, Min).
% Min is the smallest number in the list L.
min_in_list([Min], Min).
min_in_list([X, Y | L], Min) :-
	X < Y,
	min_in_list([X | L], Min).
min_in_list([X, Y | L], Min) :-
	X >= Y,
	min_in_list([Y | L], Min).

% delete_from_list(L, E, L1).
% L1 is the same list as L but without the element E.
delete_from_list([Del|L], E, L).
delete_from_list([H|L], E, [H|L1]) :-
	delete_from_list(L, E, L1).

% sort(L, LS).
% LS is the sorted list of L.
ssort([], []).
ssort(L, [Min|LS]) :-
	min_in_list(L, Min),
	delete_from_list(L, Min, L1),
	ssort(L1, LS).

% split(L, Pivot, L1, L2).
% L is splitted into L1 and L2.
% L1 contains all elements that is less than Pivot.
% L2 contains all elements that is higher than Pivot.
split([], _, [], []).
split([X1 | L], Pivot, [X1 | L1], L2) :-
	X1 < Pivot,
	split(L, Pivot, L1, L2).
split([X1 | L], Pivot, L1, [X1 | L2]) :-
	X1 >= Pivot,
	split(L, Pivot, L1, L2).

% qsort(L, LS).
% LS is the sorted list of L.
qsort([], []).
qsort([N | L], LS) :-
	split(L, N, Less, More),
	qsort(Less, L1),
	qsort(More, L2),
	print(L2),
	append(L1,  [N | L2], LS).
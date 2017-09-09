% Exercise 2.1

sorted([X1, X2]) :-
	X1<=X2.

sorted([X1, X2 | List]) :-
	X1<=X2,
	sorted([X2 | List]).

ssort(L, []) :-
	sorted(L).

ssort(L, LS) :-
	min_list(L, Min),
	delete(L, Min, L1),
	ssort(L1, [Min|LS]).

qsort([X1 | L], LS) :-
	split(L, X1, L1, L2),
	qsort(L1),
	qsort(L2),
	append(L1, L2, LS).
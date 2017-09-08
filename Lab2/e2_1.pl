% Exercise 2.1

sorted([X1, X2]) :-
	X1<X2.

sorted([X1, X2 | List]) :-
	X1<X2,
	sorted([X2 | List]).
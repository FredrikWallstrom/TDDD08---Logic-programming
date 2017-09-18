% Exercise 2.4

% union(S1, S2, Res).
% Res is the result you get if you take the union of the sets S1 and S2.
union(S1, S2, Res) :-
	append(S1, S2, Unsorted),
	sort(Unsorted,Res).

% intersection(S1, S2, Res)
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
	sort(S, Sorted),
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





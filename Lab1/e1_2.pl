connected(a,b).
connected(a,c).
connected(b,c).
connected(c,d).
connected(c,e).
connected(d,h).
connected(d,f).
connected(e,f).
connected(e,g).
connected(f,g).

% Two nodes X and Y are related if there is a edge between them.
path(X,Y) :-
	connected(X,Y).

% Base case for the recursion.
path(X,Y,[X,Y]) :-
	connected(X,Y).

% Recursion to check if there is path between X and Y.
% Record the path between X and Y in the list.
path(X,Y,[X,Z|List]) :-
	connected(X,Z),
	path(Z,Y,[Z|List]).

% Describes the relation between two nodes X and Y, 
% with both the path and the length of the path from X to Y.
npath(X,Y,[N|List]) :-
	path(X,Y,List),
	length(List,N).

/* Example queries for the program are listed below.
1. | ?- path(a,c). % Is a and c related to each other.
	yes
2. | ?- path(d,g). % Is d and g related to each other.
	no
3. | ?- path(a,e,L). % Is there a path between a and e, store the path in L.
	L = [a,b,c,e] ? ;
	L = [a,c,e] ? :
	no
4. | ?- path(f,c,L). % Is there a path between f and c, store the path in L.
	no
5.	| ?- npath(a,e,L). % Is there a path between a and e, store the length of 				     % the path and the path in L.
	L = [4,a,b,c,e] ? ;
	L = [3,a,c,e] ? ;
	no
6. | ?- npath(f,c,L). % Is there a path between f and c, store the length of 				   % the path and the path in L.
	no
*/
% Facts.
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

% path(X,Y).
% It is a path between two nodes X and Y,
% if there is a path between X and Z, then
% also a path between Z and Y.
path(X,Y) :-
	connected(X,Y).
path(X,Y) :-
	connected(X,Z),
	path(Z,Y).

% path(X,Y,[X,Y]).
% It is a path between two nodes if them are connected.
path(X,Y,[X,Y]) :-
	connected(X,Y).

% path(X,Y,[X,Z|List]).
% If two nodes X and Z are connected and
% if it is a path between Z and Y, then
% there is a path between X and Y.
path(X,Y,[X,Z|List]) :-
	connected(X,Z),
	path(Z,Y,[Z|List]).

% npath(X,Y,[N|List])
% If there is a path between X and Y and
% if the length of that path is N, then
% there is a descriptive path from X and Y.
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
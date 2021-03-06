% Given facts.
man(nisse).
man(peter).
man(bosse).
woman(ulrika).
woman(bettan).
beautiful(ulrika).
beautiful(nisse).
beautiful(peter).
rich(nisse).
rich(bettan).
strong(bettan).
strong(peter).
strong(bosse).
kind(bosse).

% likes(X, Y).
% A man like a women if she is beautiful.
likes(X,Y) :- 
	man(X), 
	woman(Y), 
	beautiful(Y).

% likes(nisse, Y).
% Nisse likes all women who like him
likes(nisse, Y) :- 
	woman(Y),
	likes(Y,nisse).

% likes(ulrika, X).
% Ulrika likes all men who likes her if they are rich and kind.
likes(ulrika, X) :- 
	man(X), 
	rich(X), 
	kind(x),
	likes(X,ulrika).

% likes(ulrika, X).
% Ulrika likes all men who likes her if they are beautiful and strong.
likes(ulrika, X) :- 
	man(X),
	beautiful(X), 
	strong(X),
	likes(X,ulrika).

% happy(X)
% All rich are happy.
happy(X) :- 
	rich(X).

% happy(X).
% If a man likes a women that likes him, then he is happy.
happy(X) :- 
	man(X), 
	woman(Y), 
	likes(X,Y), 
	likes(Y,X).

% happy(Y)
% If a woman likes a man that likes her, then she is happy.
happy(Y) :- 
	man(X), 
	woman(Y), 
	likes(Y,X), 
	likes(X,Y).

/* Queries to see if the programs work are listed below.
1. | ?- happy(X). % Who (X) is happy.
	X = nisse ? ;
	X = bettan ? ;
	X = peter ? ;
	X = ulrika ? ;
	no
2. likes(X,Y). % Who (X) likes who (Y).
	X = nisse,
	Y = ulrika ? ;
	X = peter,
	Y = ulrika ? ;
	X = bosse,
	Y = ulrika ? ;
	X = ulrika,
	Y = peter ? ;
	no
3.	findall(X, likes(X,ulrika), L), length(L, N). % Who (L) likes ulrika and 											   % how many (N) are they.
	L = [nisse,peter,bosse],
	N = 3 ? ;
	no
*/

% In what way should you arrange the clauses (rules and facts) in the program?
%
% You should arrange the clauses of the program so it would be so efficient
% and effective as possible.
% We also want to arrange them so we can terminate and dont reach the infinity
% loop. The program is read from top to bottom so for example we want
% to have a "base" predicate before the recursion predicate, so we
% can terminate.

% In what way should the premises of rules be arranged?
%
% The premises of the rules should be arranged in a way so the rules can
% terminate. We dont want the infinity loop.
% Otherwise should them be arranged so the program will be so effective
% and efficient as possible.
% We want to get as much information as possible before we do the "big" check,
% for example we can check if X and Y is a man and women before we check if
% they like each other.






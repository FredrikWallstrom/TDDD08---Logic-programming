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

% All men likes beautiful womans.
likes(X,Y) :- 
	man(X), 
	woman(Y), 
	beautiful(Y).

% Nisse likes all women who like him
likes(nisse, Y) :- 
	woman(Y),
	likes(Y,nisse).

% Ulrika likes all men who likes her, provided they are rich and kind.
likes(ulrika, X) :- 
	man(X), 
	rich(X), 
	kind(x),
	likes(X,ulrika).

% Ulrika likes all men who likes her, provided they are beatiful and strong.
likes(ulrika, X) :- 
	man(X),
	beautiful(X), 
	strong(X),
	likes(X,ulrika).

% All rich men/woman (X) are happy.
happy(X) :- 
	rich(X).

% Men (X) who like a woman (Y) who likes him are happy.
happy(X) :- 
	man(X), 
	woman(Y), 
	likes(X,Y), 
	likes(Y,X).

% Woman (Y) who like a man (X) who likes her are happy.
happy(Y) :- 
	man(X), 
	woman(Y), 
	likes(Y,X), 
	likes(X,Y).

/* Queries to see if the programs work are listed below.
1. Who is happy - happy(X).
2. Who likes who - likes(X,Y).
3. How many likes ulrika - findall(X, likes(X,ulrika), L), length(L, N).
*/

% In what way should you arrange the clauses (rules and facts) in the program?
%
% You should arrange the clauses of the program so it would be so efficient
% and effective as possible.

% In what way should the premises of rules be arranged?
%
% The premises of the rules should be arranged in a way so the rules can
% terminate. We dont want the infinity loop.
% Otherwise should them be arranged so the program will be so effective
% and efficient as possible.






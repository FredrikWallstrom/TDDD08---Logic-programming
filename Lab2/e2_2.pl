% Exercise 2.1

% middle(X,Xs)
% X is the middle element in the list Xs
middle(X, [First|Xs]) :-
	append(Middle, [Last], Xs),
	middle(X, Middle).
middle(X, [X]).
	
/*
Case 1 - Order:

middle(X, [X]).
middle(X, [First|Xs]) :-
	append(Middle, [Last], Xs),
	middle(X, Middle).

| ?- middle(X, [a,b,c]).
X = b ? ;
no

| ?- middle(a,X).
X = [a] ? ;
X = [_A,a,_B] ? ;
X = [_A,_B,a,_C,_D] ? ;
X = [_A,_B,_C,a,_D,_E,_F] ? ;
X = [_A,_B,_C,_D,a,_E,_F,_G,_H] ? ;
X = [_A,_B,_C,_D,_E,a,_F,_G,_H,_I|...] ? ;
X = [_A,_B,_C,_D,_E,_F,a,_G,_H,_I|...] ? 
yes

(1) What happens?
The program terminates as we wanted for both queries.
In the first query we got the b element, wich is in the middle.
In the second query we got every lists where a can be in the middle,
so here we got unlimited answers.
(2) Why?
We got this behavior because first we split the list (without the 
first element) into two list. One list with the first elements (in this
case this list is only one element long, and is the middle element), 
and one list with the last element.
This will succeed and after that we do a recursively call to middle again.
In this case we first check if the list is one element long, and it is!
So we have recursively scaled down the original list to consisting of one
element. This element is then the middle element of original list.
(3) SLD Tree
See attachment 1
*/

/*
Case 2 - Order:

middle(X, [X]).
middle(X, [First|Xs]) :-
	middle(X, Middle),
	append(Middle, [Last], Xs).
	
| ?- middle(X,[a,b,c]).
X = b ? ;
^CProlog interruption (h for help)? a
Execution aborted

| ?- middle(a,X).
X = [a] ? ;
X = [_A,a,_B] ? ;
X = [_A,_B,a,_C,_D] ? ;
X = [_A,_B,_C,a,_D,_E,_F] ? ;
X = [_A,_B,_C,_D,a,_E,_F,_G,_H] ? ;
X = [_A,_B,_C,_D,_E,a,_F,_G,_H,_I|...] ? ;
X = [_A,_B,_C,_D,_E,_F,a,_G,_H,_I|...] ? ;
X = [_A,_B,_C,_D,_E,_F,_G,a,_H,_I|...] ? 
yes

(1) What happens?
The program didn't terminates as we wanted for both queries.
In the first query we got the b element, wich is in the middle.
But after that we was stuck in a infinity loop.
In the second query the program terminated as we wanted. we got every 
lists where a can be in the middle, so here we got unlimited answers.
(2) Why?
We got this behavior because in the first query we call middle recursively
with unknown variable Middle. 

(3) SLD Tree
See attachment 2
*/

/*
Case 3 - Order:

middle(X, [First|Xs]) :-
	middle(X, Middle),
	append(Middle, [Last], Xs).
middle(X, [X]).

| ?- middle(X,[a,b,c]).
^CProlog interruption (h for help)? a
% Execution aborted

| ?- middle(a,X).
^CProlog interruption (h for help)? a
% Execution aborted

(1) What happens?
(2) Why?
(3) SLD Tree
See attachment 3
*/

/*
Case 4 - Order:

middle(X, [First|Xs]) :-
	append(Middle, [Last], Xs),
	middle(X, Middle).
middle(X, [X]).

| ?- middle(X,[a,b,c]).
X = b ? ;
no

| ?- middle(a,X).
X = [_A,a,_B] ? ;
X = [_A,_B,a,_C,_D] ? ;
X = [_A,_B,_C,a,_D,_E,_F] ? ;
X = [_A,_B,_C,_D,a,_E,_F,_G,_H] ? ;
X = [_A,_B,_C,_D,_E,a,_F,_G,_H,_I|...] ? ;
X = [_A,_B,_C,_D,_E,_F,a,_G,_H,_I|...] ? ;
X = [_A,_B,_C,_D,_E,_F,_G,a,_H,_I|...] ? 
yes

(1) What happens?
(2) Why?
(3) SLD Tree
See attachment 4
*/


	


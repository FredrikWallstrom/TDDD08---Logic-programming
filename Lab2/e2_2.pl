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
We got this behavior because with the first query  we go into the 
second predicate since that the only ones that matches the query. 
We derive the list to a new list without the first and the last element.
Than we call middle again and this time we go into the first predicate
since that one matches with the query. Here we found one solutio, 
that b is in the middle. After that we go into the second query with
only one list of length 1, this will lead to failure and b is the only
solution.
In the second query we go into the first predicate and find a solution
directly with a in the middle. After that we keep going into second predicate
in hope to find another solution. Here we found another solution that X also
can be of length 3 with a in the middle. This behavior will continue and just
increase the list with 2 variables all the time.
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
with unknown variable Middle. First we will find b as a solution but 
after that we will keep searching for more solution since the Middle
variable is unknown. 
In the second query we got the same behavior as in Case 1.

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
In both query we got infinity loop.
(2) Why?
We get the loop in the first query because we keep searching with the first
predicate all the time, The SLD-tree represent the searching in a good
way. Prolog always choose the leftmost answer in the tree all the time, 
and we just keep searching to the left.
Same thing happens in the second query, we just expand the search tree
to the left.

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
In first query we got the expected result.
In second query we got all the results we want except for X = [a].
(2) Why?
In the first query we got the expected results because we first search
in the left tree and it will break down into empty list, so there is no
middle in a empty list. So we will go and search in the right tree and
found that b is the only solution.
In the second query we will first try to run the middle with one element. 
We will go into the left tree and not the right. That is the reason we 
missing X = [a].
Than we call middle again, with an empty list this time and we will fail, to
the left tree. 
Than we try to call middle again to the right branch on the second level,
here we need the same elements (a and [a]).
So The only solution there is that L1 needs to be substituted with a 
and therefore x needs to be substituted with a list of 3 elements 
(because of the append statement). So we got one answer.
Than we will keep looking for more answers and go down to 3 level,
there we will find a solution on the same way as above, but this time
x needs to be substituted with a list of 5 element.
This behavior will keep going to infinity.
(3) SLD Tree
See attachment 4
*/

/*
The conclusion I make of this is that the first case is the best.
I make that conclusion from the SLD-trees. In the first case we got
the best behavior for the querys and also we got the right answers
for both querys with that order of predicates and premises within them.
With "best behavior" I mean that we got an answer in the left subtree
of the SLD-tree as soon as possible, which is good!
*/

	


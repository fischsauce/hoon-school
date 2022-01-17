!:

:: Leaf Counting


|=  a=*                                                 ::  1
^-  @                                                   ::  2
?@  a                                                   ::  3
  1                                                     ::  4
(add $(a -.a) $(a +.a))                                 ::  5


:: This program is pretty simple. If the noun a is an atom, then it's a tree of one leaf; return 1. Otherwise, the number of leaves in a is the sum of the leaves in the head, -.a, and the tail, +.a.

:: We have been careful to use -.a and +.a only on a branch for which a is proved to be a cell -- then it's safe to treat a as having a head and a tail.


:: What makes this program is little harder to follow is that it has a recursion call within a recursion call. 

    :: The first recursion expression on line 6 makes changes to two face values: c, the counter, and a, the input noun. 

    :: The new value for c defined in line 7 is another recursion call (this time in irregular syntax). 

    :: The new value for c is to be: the result of running the same function on the the head of a, -.a, and with 1 added to c. 

    :: We add 1 because we know that a must be a cell. Otherwise, we're asking for the number of cells in the rest of -.a.

    :: Once that new value for c is computed from the head of a, we're ready to check the tail of a, +.a. We've already got everything we want from -.a, so we throw that away and replace a with +.a.
!:

:: Fibonacci Sequence v2

:: |=  n=@ud
:: %-  flop
:: =+  [i=0 p=0 q=1 r=*(list @ud)]
:: |-  ^+  r
:: ?:  =(i n)  r
:: %=  $
::   i  +(i)
::   p  q
::   q  (add p q)
::   r  [q r]
:: ==


:: we use |= to produce a gate which takes an @ud that's stored in the face n:
|=  n=@ud

:: we use flop on the output of the rest of the program:
%-  flop

:: with lists, adding an element to the end is a computationally expensive operation that gets more expensive the longer the list is. 

:: (!) adding to the end of a list is O(n) and the front is O(1) (!)

:: we declare several values that we are going to use during the execution of our program. We're using * to bunt, or get the default value for, the mold (list @ud):
=+  [i=0 p=0 q=1 r=*(list @ud)]

:: we define |-, the trap that acts as a recursion point and contains the rest of our program. We also use ^+ to cast the output; this will result in the output being the same type as r, a list of @ud:
|-  ^+  r

:: ?: checks whether the first child, =(i n) (our terminating case), is true or false. If it is true, it branches to r and the program ends:
?:  =(i n)  r

:: this expression calls the $ arm of the trap:
%=  $

:: we increment i:
  i  +(i)

:: set p to be q:
  p  q

:: q becomes the sum of p and q:
  q  (add p q)

:: r becomes a cell of q and whatever r was previously:
  r  [q r]
==

:: The list built from this is the one that will get flopped to produce the result at the end of the computation.

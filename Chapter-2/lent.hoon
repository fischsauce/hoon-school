!:
    
:: Here's a program using ?~ to calculate the number of items in a list of atoms:

|=  a=(list @)              ::  1
=|  c=@                     ::  2
|-  ^-  @                   ::  3
?~  a                       ::  4
    c                         ::  5
$(c +(c), a t.a)            ::  6


:: This function takes a list of @ and returns an @. 

:: It uses c as a counter value, initially set at 0 on line 2. 

:: If a is ~ (i.e., a null list) then the computation is finished; return c. 

:: Otherwise a must be a non-null list, in which case there is a recursion to the |- on line 3, but with c incremented, and with the head of the list a thrown away.



:: (!) It's important to note that if a is a list, you can only use i.a and t.a after Hoon has inferred that a is non-null (!)

:: A null list has no i or t in it! You'll often use ?~ to distinguish the two kinds of list (null and non-null). If you use i.a or t.a without showing that a is non-null you'll get a find-fork-d crash.

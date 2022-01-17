!:

:: Here's a program that takes a noun and returns a list of its 'leaves' (atoms) in order of their appearance:

|=  a=*                               ::  1
=/  lis=(list @)  ~                   ::  2
|-  ^-  (list @)                      ::  3
?@  a                                 ::  4
    [i=a t=lis]                       ::  5
$(lis $(a +.a), a -.a)                ::  6


:: The input noun is a. The list of atoms to be output is lis, which is given an initial value of ~. 

:: If a is just an atom, return a non-null list whose head is a and whose tail is lis. 

:: Otherwise, the somewhat complicated recursion in line 6 is evaluated, in effect looping back to the |- with modifications made to lis and a.


:: The modification to lis in line 6 is to $(a +.a). 

:: The latter is a recursion to |- but with a replaced by its tail. This evaluates to the list of @ in the tail of a. 

:: So lis becomes the list of atoms in the tail of a, and a becomes the head of a, -.a.

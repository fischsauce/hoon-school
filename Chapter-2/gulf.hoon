!:

:: Here's a program that takes atoms a and b and returns a list of all atoms from a to b:

|=  [a=@ b=@]                      ::  1
^-  (list @)                       ::  2
?:  (gth a b)                      ::  3
    ~                              ::  4
[i=a t=$(a +(a))]                  ::  5


:: This program is very simple. It takes two @ as input, a and b, and returns a (list @), i.e., a list of @. 

:: If a is greater than b the list is finished: return the null list ~. 

:: Otherwise, return a non-null list: a pair in which the head is a with an i face on it, and in which the tail is another list with the t face on it. 

:: This embedded list is the product of a recursion call: add 1 to a and run the function again.

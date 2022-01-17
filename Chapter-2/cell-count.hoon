!:

:: Cell Counting

|=  a=*                        ::  1
=|  c=@                        ::  2
|-  ^-  @                      ::  3
?@  a                          ::  4
    c                          ::  5
%=  $                          ::  6
    c  $(c +(c), a -.a)        ::  7
    a  +.a                     ::  8
==                             ::  9


:: This code is a little more tricky. The basic idea, however, is simple. 

:: We have a counter value, c, whose initial value is 0. We trace through the noun a, adding 1 to c every time we come across a cell. 

:: For any part of the noun that is just an atom, c is returned unchanged.

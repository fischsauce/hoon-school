!:


:: Cartesian Product

:: Here's a program that takes two sets of atoms and returns the Cartesian product of those sets. 

:: A Cartesian product of two sets a and b is a set of all the cells whose head is a member of a and whose tail is a member of b

|=  [a=(set @) b=(set @)]
=/  c=(list @)  ~(tap in a)
=/  d=(list @)  ~(tap in b)
=|  acc=(set [@ @])
|-  ^-  (set [@ @])
?~  c  acc
%=  $
c  t.c
acc  |-  ?~  d  acc
    %=  $
        d  t.d
        acc  (~(put in acc) [i.c i.d])
    ==
==


:: Save this as cartesian.hoon in your urbit's pier and run in the dojo:

:: =c `(set @)`(sy ~[1 2 3])

:: c
:: :: {1 2 3}

:: =d `(set @)`(sy ~[4 5 6])

:: > d
:: :: {5 6 4}

:: +cartesian [c d]
:: :: {[2 6] [1 6] [3 6] [1 4] [1 5] [2 4] [3 5] [3 4] [2 5]}

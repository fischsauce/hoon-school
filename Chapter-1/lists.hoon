!:
:: Lists

    :: A list can be thought of as an ordered arrangement of zero or more elements terminated by a ~ (null).

    :: So a list can be either null or non-null.

    :: Non-null lists, called lests, are cells in which the head is the first list item, and the tail is the rest of the list. 
    
    :: The tail is itself a list, and if such a list is also non-null, the head of this sublist is the second item in the greater list, and so on.
    
    :: To illustrate, let's look at a list [1 2 3 4 ~] with the cell-delineating brackets left in:

    [1 [2 [3 [4 ~]]]]
    :: [1 2 3 4 ~]

    :: The head of the above list is the atom 1 and the tail is the list [2 [3 [4 ~]]], (or [2 3 4 ~]). Recall that whenever cell brackets are omitted so that visually there appears to be more than two child nouns, it is implicitly understood that the right-most nouns constitute a cell.

    :: To make a list, let's cast nouns to the (list @) ("list of atoms") type:

    `(list @)`~
    :: ~

    `(list @)`[1 2 3 4 5 ~]
    :: ~[1 2 3 4 5]

    `(list @)`[1 [2 [3 [4 [5 ~]]]]]
    :: ~[1 2 3 4 5]

    `(list @)`~[1 2 3 4 5]
    :: ~[1 2 3 4 5]

    :: ~[1 2] is semantically identical to [1 2 ~].




:: An aside about Casting

    :: Let's make a list whose items are of the @t string type:

    `(list @t)`['Urbit' 'will' 'rescue' 'the' 'internet' ~]
    :: <|Urbit will rescue the internet|>



    :: The head of a list has the face i and the tail has the face t. (For the sake of neatness, these faces aren't shown by the Hoon pretty printer.) 
    
    :: To use the i and t faces of a list, you must first prove that the list is non-null by using the conditional family of runes, ?:

    =>(b=`(list @)`[1 2 3 4 5 ~] i.b)
    :: -find.i.b
    :: find-fork-d
    :: dojo: hoon expression failed

    =>(b=`(list @)`[1 2 3 4 5 ~] ?~(b ~ i.b))
    :: 1

    =>(b=`(list @)`[1 2 3 4 5 ~] ?~(b ~ t.b))
    :: ~[2 3 4 5]

    :: => IS A REVERSED FOR OF THE : operator we've been using, meaning that (!) => a b is the same as b:a (!)

    :: ... this means we're evaluating the ?~ expression with the b=... expression as the subject. 

    :: (!) performing tests like ?~ mylist will actually transform mylist into a lest, a non-null list. (!)

    (list @)        :: list of ATOMS
    (list ^)        :: list of CELLS
    (list [@ ?])    :: list of cells whose HEAD is an ATOM and whose TAIL is a FLAG




:: Tapes and Cords

    :: There are some special types of lists that are built into Hoon. The TAPE is the most common example.

    :: Hoon has two kinds of strings:
    
        :: CORDS are atoms with aura @t, and they're pretty-printed between '' marks.

            'this is a cord'
            :: 'this is a cord'

            `@`'this is a cord'
            :: 2.037.307.443.564.446.887.986.503.990.470.772


        :: TAPES are lists of @tD atoms (i.e., ASCII characters):

            "this is a tape"
            :: "this is a tape"

            `(list @)`"this is a tape"
            :: ~[116 104 105 115 32 105 115 32 97 32 116 97 112 101]


        :: You can also use the words CORD and TAPE for casting:

            `tape`"this is a tape"
            :: "this is a tape"

            `cord`'this is a cord'
            :: 'this is a cord'



:: List Functions in the Hoon Standard Library


    :: flop

        :: takes a list and returns it in reverse order:
        (flop ~[11 22 33])
        :: ~[33 22 11]



    :: sort

        ::  uses the "quicksort" algorithm to sort a list. It takes a list to sort and a gate that serves as a comparator. 


        ::  if you want to sort the list ~[37 62 49 921 123] from LEAST to GREATEST, you would pass that list along with the lth gate (for "less than"):

            (sort ~[37 62 49 921 123] lth)
            :: ~[37 49 62 123 921]


        :: from GREATEST to LEAST, use the gth gate ("greater than") instead:

            (sort ~[37 62 49 921 123] gth)
            :: (sort ~[37 62 49 921 123] gth)


        :: You can sort LETTERS this way as well:

            (sort ~['a' 'f' 'e' 'k' 'j'] lth)
            :: <|a e f j k|>



    :: weld

        :: takes two lists of the same type and CONCATENATES them:

            (weld ~[1 2 3] ~[4 5 6])
            :: ~[1 2 3 4 5 6]

            (weld "Happy " "Birthday!")
            :: "Happy Birthday!"



    :: snag

        :: takes an atom n and a list, and returns the nth item of the list, where 0 is the first item:

            (snag 0 `(list @)`~[11 22 33 44])
            :: 11

            (snag 3 "Hello!")
            :: 'l'

            :: (!) some of these functions to fail when passed a list b after some type inference has been performed on b (!)


    
    :: oust

        :: takes a pair of atoms [a=@ b=@] and a list, and returns the list with b items removed, starting at a:

            (oust [0 1] `(list @)`~[11 22 33 44])
            :: ~[22 33 44

            (oust [0 2] `(list @)`~[11 22 33 44])
            :: ~[33 44]
        
            (oust [2 2] "Hello!")
            :: "Heo!"



    :: lent

        :: takes a list and returns the number of items in it:

        (lent ~[11 22 33 44])
        :: 4




    :: roll 

        :: takes a list and a gate, and accumulates a vaule of the list items using that gate.

        :: eg, if you want to add or multiply all the items in a list of atoms, you would use roll:

            (roll `(list @)`~[11 22 33 44 55] add)
            :: 165

            (roll `(list @)`~[11 22 33 44 55] mul)
            :: 19.326.120



    :: turn

        :: takes a list and a gate, and returns a list of the products of applying each item of the input list to the gate.

        :: eg, to add 1 to each item in a list of atoms:

            (turn `(list @)`~[11 22 33 44] |=(a=@ +(a)))
            :: ~[12 23 34 45]


        :: ...or to double each item in a list of atoms:

            (turn `(list @)`~[11 22 33 44] |=(a=@ (mul 2 a)))
            :: ~[22 44 66 88]


        :: (!) turn is Hoon's version of Haskell's map (!)


:: Additional Exercises:

    :: 1.5e  what are the products of the following expressions?

        (lent ~[1 2 3 4 5])
        :: 5        o

        (lent ~[~[1 2] ~[1 2 3] ~[2 3 4]])
        :: 8        x       3       Why?
        :: lent is only counting the parent cells?

        (lent ~[1 2 (weld ~[1 2 3] ~[4 5 6])])
        :: 8        x       3       Why?
        :: as above. RHS evaluates to ~[1 2 3 4 5 6], which counts as 1. LHS stays as ~[1 2 ..[]] which counts as two.


    :: 1.5f  bind these faces:

        =b ~['moon' 'planet' 'star' 'galaxy']
        =c ~[1 2 3]

        :: determine whether the following Dojo expressions are valid, and if so, what they evaluate to:

            (weld b b)
            :: ['moon' 'planet' 'star' 'galaxy' 'moon' 'planet' 'star' 'galaxy']    o

            (weld b c)
            :: Invalid because b is composed of nouns, whilse c is pure @atoms.

            (lent (weld b c))
            :: As above: Invalid because b is composed of nouns, whilse c is pure @atoms.

            (add (lent b) (lent c))
            :: (lent b) -> 4, (lent c) -> 3 ergo total is 7.    o


    :: 1.5g Write a gate that takes in a list a and returns %.y if a is a palindrome and %.n otherwise. You may make use of the flop function.

        :: see palidrome.hoon





       
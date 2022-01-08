!:

:: Exercise 1.5g

    :: Write a gate that takes in a list a and returns %.y if a is a palindrome and %.n otherwise. You may make use of the flop function.


|=  a=(list @)
|-
?:  =(a (flop a))  `@t`'True'  `@t`'False'

    :: This works, but how do i enable normal boolean types as the output here?


    :: From the docs, the solutution is more simple:

        :: |=  a=(list)
        :: =(a (flop a))


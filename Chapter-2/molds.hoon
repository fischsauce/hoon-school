!:

:: 2.3.2 Molds

    :: A mold is an idempotent function that coerces a noun to be of a specific type or crashes.



    :: +$ Creates a core with an arm

        :: The simplest molds to understand are arms of cores created with +$

            +$  height  [feet=@ud inches=@ud]


        :: A mold is compiled to a gate that takes in any noun and produces a typed value, or crashes:

            (height [5 11])
            ::  produces [feet=5 inches=11]
            (height %wrong)
            ::  crashes



        :: To coerce using a gate, it's good practice to use the ;; rune, which can parse inline molds.

            ;;(height [5 11])
            ::  produces [feet=5 inches=11]

            ;;([feet=@ud inches=@ud] [5 11])
            ::  produces [feet=5 inches=11]





    :: |$ is the mold builder rune which takes a list of molds and produces a mold.


        :: |$ implements parametric polymorphism in Hoon, and as such we call gates produced with |$ a wet gate. 
        
        :: We discuss what this means in further detail in the upcoming lesson on polymorphism.



        :: Let's look at some examples from hoon.hoon.

            :: Here is a very simple mold builder. It takes two molds and produces a mold that is a pair of those with the faces p and q. An example of using this would be (pair @ud @ud) which would produce a mold for a cell of @ud and @ud:

                ++  pair
                |$  [head tail]
                [p=head q=tail]



            :: 'each' is very slightly more complicated than pair. $% is a rune that is a tagged union. 
            
            :: The mold produced by this will match either this or that. An example of this would be (each @ud @tas) which will match either an @ud or a @tas:

                ++  each
                  |$  [this that]
                  $%  [%| p=that]
                      [%& p=this]
                  ==
            



            :: Here is a mold builder you've used previously. 
            
            :: $@ is a rune that will match the first thing if its sample is an atom and the second if the sample is a cell. 
            
            :: You should be familiar at this point that a list is either ~ or a pair of an item and a list of item.

                ++  list
                  |$  [item]
                  $@(~ [i=item t=(list item)])




            :: 'lest' you may have heard of as a "non empty list." 
            
            :: You can see that it lacks the ~ case that list has but it matches the second part of the list definition:

                ++  lest
                  |$  [item]
                  [i/item t/(list item)]

            



            :: Remember that Hoon types are defined by shape. list could also have been defined in terms of lest like this:

                ++  list
                  |$  [item]
                  $@(~ lest)

            :: Another possible way to write it could have been:

                ++  list
                  |$  [item]
                  $@(~ [i=item t=$])

            :: Any of these would be equivalent.

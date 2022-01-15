!:

:: Type Checking and Type Inference

    :: As the Hoon compiler compiles your Hoon code, it does a type check on certain expressions to make sure they are guaranteed to produce a value of the correct type. If it cannot be proved that the output value is correctly typed, the compile will fail with a nest-fail crash. 
    
    :: In order to figure out what type of value is produced by a given expression, the compiler uses type inference on that code. In this lesson we'll cover various cases in which a type check is performed, and also how the compiler does type inference on an expression.



    :: Type Checking

        :: Let's enumerate the most common cases where a type check is called for in Hoon.



        :: Cast Runes

            :: The most obvious case is when there is a cast rune in your code. These runes don't directly have any effect on the compiled result of your code; they simply indicate that a type check should be performed on a piece of code at compile-time.



            :: ^- Cast with a Type

                :: You've already seen one rune that calls for a type check: ^-:

                    ^-(@ 12)
                    :: 12

                    ^-(@ 123)
                    :: 123

                    ^-(@ [12 14])
                    :: nest-fail

                    ^-(^ [12 14])
                    :: [12 14]

                    ^-(* [12 14])
                    :: [12 14]

                    ^-(* 12)
                    :: 12

                    ^-([@ *] [12 [23 43]])
                    :: [12 [23 43]]

                    ^-([@ *] [[12 23] 43])
                    :: nest-fail



            :: ^+ Cast with an Example Value

                :: The rune ^+ is like ^-, except that instead of using a type name for the cast, it uses an example value of the type in question. E.g.:

                    ^+(7 12)
                    :: 12

                    ^+(7 123)
                    :: 123

                    ^+(7 [12 14])
                    :: nest-fail

                :: The ^+ rune takes two subexpressions.
                
                :: The first subexpression is evaluated and its type is inferred. 
                
                :: The second subexpression is evaluated and its inferred type is compared against the type of the first. 
                
                :: If the type of the second provably nests under the type of the first, the result of the ^+ expression is just the value of its second subexpression. Otherwise, the code fails to compile.


                :: This rune is useful for casting when you already have a noun -- or expression producing a noun -- whose type you may not know or be able to construct easily. If you want your output value to be of the same type, you can use ^+.


                :: More examples:

                    ^+([12 13] [123 456])
                    :: [123 456]

                    ^+([12 13] [123 [12 14]])
                    :: nest-fail

                    ^+([12 [1 2]] [123 [12 14]])
                    :: [123 12 14]



            :: The .= and .+ Runes

                :: You saw earlier in Chapter 1 how a type check is performed when .= -- or its irregular variant, =( ) -- is used. 
                
                :: For any expression of the form =(a b), either the type of a must be a subset of the type of b or the type of b must be a subset of the type of a. Otherwise, the type check fails and you'll get a nest-fail.

                    =(12 [33 44])
                    :: nest-fail

                    =([77 88] [33 44])
                    :: %.n


                :: You can evade the .= type-check by casting one of its subexpressions to a *, under which all other types nest:

                    .=(`*`12 [33 44])
                    :: %.n

                :: It isn't recommended that you evade the rules in this way, however.


                :: The .+ increment rune -- including its +( ) irregular form -- does a type check to ensure that its subexpression must evaluate to an atom.

                    +(12)
                    :: 13

                    +([12 14])
                    :: nest-fail




        :: Arm Evaluations

            :: Whenever an arm is evaluated in Hoon it expects to have some version of its parent core as the subject. Specifically, a type check is performed to see whether the arm subject is of the appropriate type. We see this in action whenever a gate or a multi-arm door is called.


            :: A gate is a one-armed core with a sample. 
            
            :: When it is called, its $ arm is evaluated with (a version of) the gate as the subject. 
            
            :: The only part of the core that might change is the payload, including the sample. 
            
            :: Of course, we want the sample to be able to change. The sample is where the argument(s) of the function call are placed. 
            
            :: For example, when we call add the $ arm expects two atoms for the sample, i.e., the two numbers to be added. When the type check occurs, the payload must be of the appropriate type. If it isn't, the result is a nest-fail crash.

                (add 22 33)
                :: 55

                (add [10 22] [10 33])
                :: nest-fail

                (|=(a=@ [a a]) 15)
                :: [15 15]

                (|=(a=@ [a a]) 22)
                :: [22 22]

                (|=(a=@ [a a]) [22 22])
                :: nest-fail



        :: This isn't a comprehensive list of the type checks in Hoon. It's only some of the most commonly used kinds. Two other runes that include a type check are =. and %_.
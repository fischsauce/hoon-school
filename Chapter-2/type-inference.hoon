!:

:: Intro to Hoon Type Inference

    :: It's helpful to know that Hoon infers the type of any given expression, but it's important to know how such inference works. 
    

    :: Hoon uses various tools for inferring the type of any given expression: 

        :: literal syntax, 
        :: cast expressions, 
        :: gate sample definitions, 
        :: conditional expressions, 
        :: and more.



    :: Literals

        :: Literals are expressions that represent fixed values. 
        
        :: Some examples (with the inferred type on the right):

            :: 123                   @ud
            :: 0xabc                 @ux
            :: 0b1010                @ub
            :: [12 14]               [@ud @ud]
            :: [0x1f 'hello' %.y]    [@ux @t ?]


        :: As you can see there are both atom and cell literals in Hoon. Hoon infers the type of literals -- including atom auras -- directly from such expressions.




    :: Casts

        :: Cast runes also shape how Hoon understands an expression type.

        :: The inferred type of a cast expression is just the type being cast for. It can be inferred that, if the cast didn't result in a nest-fail, the value produced must be of the cast type. 
        

        :: Here are some examples of cast expressions with the inferred output type on the right:

            :: ^-(@ud 123)                       @ud
            :: ^-(@ 123)                         @
            :: ^-(^ [12 14])                     ^
            :: ^-([@ @] [12 14])                 [@ @]
            :: ^-(* [12 14])                     *
            :: ^+(7 123)                         @ud
            :: ^+([7 8] [12 14])                 [@ud @ud]
            :: ^+([44 55] [12 14])               [@ud @ud]
            :: ^+([0x1b 0b11] [0x123 0b101])     [@ux @ub]

        :: You can also use the irregular ` syntax for casting in the same way as ^-

            :: `@`123   for   ^-(@ 123).


    
        :: (!) One thing to note about casts is that they can 'throw away' type information (!)

        :: The second subexpression of ^- and ^+ casts may be inferred to have a very specific type. If the cast type is more general, then the more specific type information is lost. 

        :: Consider the literal [12 14]. 
        
            :: The inferred type of this expression is [@ @], i.e., a cell of two atoms. 
            
            :: If we cast over [12 14] with ^-(^ [12 14]) then the inferred type is just ^, the set of all cells. -- The information about what kind of cell it is has been thrown away.

            :: If we cast over [12 14] with ^-(* [12 14]) then the inferred type is *, the set of all nouns. -- All interesting type information is thrown away on the latter cast.


        :: (!) It's important to remember to include a cast rune with each gate expression. That way it's clear what the inferred product type will be for calls to that gate (!)





    :: (Dry) Gate Sample Definitions

        :: By now you've used the |= rune to define several gates. 
        
        :: This rune is used to produce a 'dry' gate, which has different type-checking and type-inference properties than a 'wet' gate does. 
        
        :: We won't explain the wet/dry distinction until later in Chapter 2 -- for now, just keep in mind that we're only dealing with one kind of gate (albeit the more common kind).


        :: The first subexpression after the |= defines the sample type. Any faces used in this definition have the type declared for it in this definition. Consider again the addition function:

            |=  [a=@ b=@]                   ::  take two @
            ^-  @                           ::  output is one @
            ?:  =(b 0)                      ::  if b is 0
            a                               ::    return a, else
            $(a +(a), b (dec b))            ::  add a+1 and b-1


            :: We run it in the dojo using a cell to pass the two arguments:

                +add 12 14
                :: 26

                +add 22
                :: nest-fail
                :: -want.{a/@ b/@}
                :: -have.@ud

            :: If you try to call this gate with the wrong kind of argument, you get a nest-fail. If the call succeeds, then the argument takes on the type of the sample definition: [a=@ b=@].


            :: Accordingly, the inferred type of a is @, and the inferred type of b is @. 
            
            :: In this case some type information has been thrown away; the inferred type of [12 14] is [@ud @ud], but the addition program takes all atoms, regardless of aura.




    :: Using Conditionals for Inference by Branch

        :: You learned about a few conditional runes earlier in the chapter (e.g., ?:, ?.), but other runes of the ? family are used for branch-specialized type inference. 
        

        :: The ?@, ?^, and ?~ conditionals each take three subexpressions, which play the same basic role as the corresponding subexpressions of ?: 
        
            :: The first is the test condition, which evaluates to a flag ?. If the test condition is true, the second subexpression is evaluated; otherwise the third. 
            
            :: These second and third subexpressions are the 'branches' of the conditional.


        :: There is also a ?= rune for matching expressions with certain types, returning %.y for a match and %.n otherwise.



        :: ?= Non-recursive Type Match Test

            :: The ?= rune takes two subexpressions. 
            
            :: The first subexpression should be a type. 
            
            :: The second subexpression is evaluated and the resulting value is compared to the first type. 
            
            :: If the value is an instance of the type, %.y is produced. Otherwise, %.n:

                ?=(@ 12)
                :: %.y

                ?=(@ [12 14])
                :: %.n

                ?=(^ [12 14])
                :: %.y

                ?=(^ 12)
                :: %.n

                ?=([@ @] [12 14])
                :: %.y

                ?=([@ @] [[12 12] 14])
                :: %.n


            :: ?= expressions ignore aura information:

                ?=(@ud 0x12)
                :: %.y

                ?=(@ux 'hello')
                :: %.y



            :: We haven't talked much about types that are made with a type constructor yet. We'll discuss these more soon, but it's worth pointing out that every list type qualifies as such, and hence should not be used with ?=:

                ?=((list @) ~[1 2 3 4])
                :: fish-loop

            :: Using these non-basic constructed types with the ?= rune results in a fish-loop error.




            :: Using ?= for Type Inference

                :: The ?= rune is particularly useful when used with the ?: rune, because in these cases Hoon uses the result of the ?= evaluation to infer type information. 
                

                :: To see how this works lets use =/ to define a face, b, as a generic noun:

                    =/(b=* 12 b)
                    :: 12

                :: The inferred type of the final b is just *, because that's how b was defined earlier. We can see this by using ? in the dojo to see the product type:

                    ? =/(b=* 12 b)
                    :: *
                    :: 12

                    :: (!) Remember that ? isn't part of Hoon -- it's a dojo-specific instruction. (!)


                :: Let's replace that last b with a ?: expression whose condition subexpression is a ?= test. 
                
                :: If b is an @, it'll produce [& b]; otherwise [| b]:

                    =/(b=* 12 ?:(?=(@ b) [& b] [| b]))
                    :: [%.y 12]


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

                :: You can't see it here, but the inferred type of b in [& b] is @. That subexpression is only evaluated if ?=(@ b) evaluates as true; hence, Hoon can safely infer that b must be an atom in that subexpression. 
                
                
                
                :: Let's set b to a different initial value but leave everything else the same:

                    =/(b=* [12 14] ?:(?=(@ b) [& b] [| b]))
                    :: [%.n 12 14]
                
                :: You can't see it here either, but the inferred type of b in [| b] is ^. That subexpression is only evaluated if ?=(@ b) evaluates as false, so b can't be an atom there. It follows that it must be a cell.





            :: The Type Spear


                :: We think we're trustworthy, but perhaps you don't want to take our word for it. What if you want to see the inferred type of b for yourself for each conditional branch? One way to do this is with a 'type spear'. 

                :: But you need to understand the !> rune before using this mighty weapon of war. 
                
                :: !> takes one subexpression and constructs a cell from it. 
                
                :: The subexpression is evaluated and becomes the tail of the product cell, with a q face attached. 
                
                :: The head of the product cell is the inferred type of the subexpression. Examples:

                    !>(15)
                    :: [#t/@ud q=15]

                    !>([12 14])
                    :: [#t/{@ud @ud} q=[12 14]]

                    !>((add 22 55))
                    :: [#t/@ q=77]

                :: The #t/ is just the pretty-printer's way of indicating a type.



                :: To get just the inferred type of an expression, we only want the head of the !> product, -. Thus we should use the type spear, -:!>

                    -:!>(15)
                    :: #t/@ud

                    -:!>([12 14])
                    :: #t/{@ud @ud}

                    -:!>((add 22 55))
                    :: #t/@



                :: Now let's try using ?= with ?: again. 

                :: But this time we'll replace [& b] with [& -:!>(b)] and [| b] with [| -:!>(b)]. With b as 12:

                    =/(b=* 12 ?:(?=(@ b) [& b] [| b]))


                    =/(b=* 12 ?:(?=(@ b) [& -:!>(b)] [| -:!>(b)]))
                    :: [%.y #t/@]

                        :: ...and with b as [12 14]:

                    =/(b=* [12 14] ?:(?=(@ b) [& -:!>(b)] [| -:!>(b)]))
                    :: [%.n #t/{* *}]


                :: In both cases, b is defined initially as a generic noun, *. But when using ?: with ?=(@ b) as the test condition, b is inferred to be an atom, @, when the condition is true; otherwise b is inferred to be a cell, ^ (identical to {* *}).





            :: mint-vain


                :: Expressions of the form ?:(?=(a b) c d) should only be used when the previously inferred type of b isn't specific enough to determine whether it nests under a.

                :: (!) This kind of expression is only to be used when ?= can reveal new type information about b, not to confirm information Hoon already has (!)



                :: For example, if you have a wing expression (e.g., b) that is already known to be an atom, @, and you use ?=(@ b) to test whether b is an atom, you'll get a mint-vain crash:

                    =/(b=@ 12 ?:(?=(@ b) [& b] [| b]))
                    :: mint-vain

                    :: In the first case it's already known that b is an atom.


                :: The same thing happens if b is initially defined to be a cell ^:

                    =/(b=^ [12 14] ?:(?=(@ b) [& b] [| b]))
                    :: mint-vain

                    :: In the second case it's already known that b isn't an atom. 

                
                :: Either way, the check is superfluous and thus one of the ?: branches will never be taken. 
                
                :: (!) The mint-vain crash indicates that it's provably the case one of the branches will never be taken (!)






            :: ?@ Atom Match Tests


                :: The ?@ rune takes three subexpressions. 
                
                :: The first is evaluated, and if its value is an instance of @, the second subexpression is evaluated. Otherwise, the third subexpression is evaluated.

                    =/(b=* 12 ?@(b %atom %cell))
                    :: %atom

                    =/(b=* [12 14] ?@(b %atom %cell))
                    :: %cell

                :: If the second ?@ subexpression is evaluated, Hoon correctly infers that b is an atom. if the third subexpression is evaluated, Hoon correctly infers that b is a cell.

                    =/(b=* 12 ?@(b [%atom -:!>(b)] [%cell -:!>(b)]))
                    :: [%atom #t/@]

                    > =/(b=* [12 14] ?@(b [%atom -:!>(b)] [%cell -:!>(b)]))
                    :: [%cell #t/{* *}]


                :: If the inferred type of the first ?@ subexpression nests under @ then one of the conditional branches provably never runs. Attempting to evaluate the expression results in a mint-vain:

                    ?@(12 %an-atom %not-an-atom)
                    :: mint-vain

                    ?@([12 14] %an-atom %not-an-atom)
                    :: mint-vain

                    =/(b=@ 12 ?@(b %an-atom %not-an-atom))
                    :: mint-vain

                    =/(b=^ [12 14] ?@(b %an-atom %not-an-atom))
                    :: mint-vain


                :: (!) ?@ should only be used when it allows for Hoon to infer new type information; it shouldn't be used to confirm type information Hoon already knows (!)






            :: ?^ Cell Match Tests


                :: The ?^ rune is just like ?@ except it's a test for a cell match instead of an atom match. 
                
                :: The first subexpression is evaluated, and if the resulting value is an instance of ^ the second subexpression is evaluated. Otherwise, the third is.

                    =/(b=* 12 ?^(b %cell %atom))
                    :: %atom

                    =/(b=* [12 14] ?^(b %cell %atom))
                    :: %cell



                :: Again, if the second subexpression is evaluated, Hoon infers that b is a cell; if the third, Hoon infers that b is an atom. 
                
                :: If one of the conditional branches is provably never evaluated, the expression crashes with a mint-vain:

                    =/(b=@ 12 ?^(b %cell %atom))
                    :: mint-vain

                    =/(b=^ 12 ?^(b %cell %atom))
                    :: nest-fail





            :: Leaf Counting


                :: Nouns can be understood as binary trees in which each 'leaf' of the tree is an atom. 
                
                :: Let's look at a program that takes a noun and returns the number of leaves in it, i.e., the number of atoms:

                    |=  a=*                             ::  1
                    ^-  @                               ::  2
                    ?@  a                               ::  3
                      1                                 ::  4
                    (add $(a -.a) $(a +.a))             ::  5



                :: This program is pretty simple. If the noun a is an atom, then it's a tree of one leaf; return 1. Otherwise, the number of leaves in a is the sum of the leaves in the head, -.a, and the tail, +.a:

                    +leafcount 12
                    :: 1

                    +leafcount [12 14]
                    :: 2

                    +leafcount [12 [63 [829 12] 23] 13]
                    :: 6

                :: (!) We have been careful to use -.a and +.a only on a branch for which a is proved to be a cell -- then it's safe to treat a as having a head and a tail. (!)





            :: Cell Counting

                :: Here's a program that counts the number of cells in a noun:

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

                    +cellcount 12
                    :: 0

                    +cellcount [12 14]
                    :: 1

                    +cellcount [[12 [14 15]] [15 [14 22]]]
                    :: 5


                :: What makes this program is little harder to follow is that it has a recursion call within a recursion call. 

                    :: The first recursion expression on line 6 makes changes to two face values: c, the counter, and a, the input noun. 

                    :: The new value for c defined in line 7 is another recursion call (this time in irregular syntax). 

                    :: The new value for c is to be: the result of running the same function on the the head of a, -.a, and with 1 added to c. 

                    :: We add 1 because we know that a must be a cell. Otherwise, we're asking for the number of cells in the rest of -.a.

                    :: Once that new value for c is computed from the head of a, we're ready to check the tail of a, +.a. We've already got everything we want from -.a, so we throw that away and replace a with +.a.






            :: Lists

                :: You learned about lists earlier in the chapter, but we left out a little bit of information about the way Hoon understands list types.

                    :: (!) A non-null list is a cell (!) 
                    
                    :: If b is a non-null list then the head of b is the first item of b with an i face on it. 
                    
                    :: The tail of b is the rest of the list. 
                    
                    :: The 'rest of the list' is itself another list with a t face on it. 
                    
                    :: (!) We can (and should) use these i and t faces in list functions (!)

                
                :: To illustrate: let's say that b is the list of the atoms 11, 22, and 33. Let's construct this in stages:

                    [i=11 t=[rest-of-list-b]]

                    [i=11 t=[i=22 t=[rest-of-list-b]]]

                    [i=11 t=[i=22 t=[i=33 t=~]]]


                :: (There are lists of every type. Lists of @ud, @ux, @ in general, ^, [^ [@ @]], etc. We can even have lists of lists of @, ^, or ?, etc.)



                :: Here's a program that takes atoms a and b and returns a list of all atoms from a to b:

                    |=  [a=@ b=@]                      ::  1
                    ^-  (list @)                       ::  2
                    ?:  (gth a b)                      ::  3
                      ~                                ::  4
                    [i=a t=$(a +(a))]                  ::  5

                
                :: This program is very simple. It takes two @ as input, a and b, and returns a (list @), i.e., a list of @. 
                
                :: If a is greater than b the list is finished: return the null list ~. 
                
                :: Otherwise, return a non-null list: a pair in which the head is a with an i face on it, and in which the tail is another list with the t face on it. 
                
                :: This embedded list is the product of a recursion call: add 1 to a and run the function again.

                    +gulf [1 10]
                    :: ~[1 2 3 4 5 6 7 8 9 10]

                    +gulf [10 20]
                    :: ~[10 11 12 13 14 15 16 17 18 19 20]

                    +gulf [20 10]
                    :: ~



                :: Where are all the is and ts??? For the sake of neatness the Hoon pretty-printer doesn't show the i and t faces of lists, just the items.

                    :: In fact, we could have left out the i and t faces in the program itself:

                        |=  [a=@ b=@]                   ::  1
                        ^-  (list @)                    ::  2
                        ?:  (gth a b)                   ::  3
                          ~                             ::  4
                        [a $(a +(a))]                   ::  5

                    :: Because there is a cast to a (list @) on line 2, Hoon will silently include i and t faces for the appropriate places of the noun. 
                    
                    :: (!) Remember that faces are recorded in the type information of the noun in question, not as part of the noun itself (!)



                :: We called this program gulf.hoon because it replicates the gulf function in the Hoon standard library:

                    (gulf 1 10)
                    :: ~[1 2 3 4 5 6 7 8 9 10]

                    (gulf 10 20)
                    :: ~[10 11 12 13 14 15 16 17 18 19 20]
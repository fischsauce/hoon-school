!:

:: Arms & Cores


    :: A Preliminary Explanation

        :: Arms and legs are limbs of the subject, i.e., noun fragments of the subject.

        :: An arm is some expression of Hoon encoded as a noun. (By 'encoded as a noun' we literally mean: 'compiled to a Nock formula'.)

        :: Think of an arm simply as a way of running some Hoon code.



        :: :Every expression of Hoon is evaluated relative to a subject. What subject is the arm to be evaluated against? Answer: the parent core of that arm.



        :: (!) a core is a cell of [battery payload] (!) 
        
        :: The battery is a collection of one or more arms, and the payload is the data needed by the arms to evaluate correctly. (The battery is code and the payload is data for that code.) A given core is the parent core of all of the arms in its battery.



    :: Your First Core

        :: We'll make a core using a multi-line Hoon expression that is more complex than the other examples you've seen up to this point. 
        
        :: The dojo can be used to input multi-line Hoon expressions; just type each line, hitting 'enter' or 'return' at the end. 
        
        :: The expression will be evaluated at the appropriate line break, i.e., when the dojo recognizes it as a complete expression of Hoon.



        :: Use the following to bind c to a core. 
        
            :: It begins with a rune, |%, which is used for creating a core. (A rune is just a pair of ASCII characters, and it usually indicates the beginning of a complex Hoon expression.) 
            
            :: Take note of the expression spacing -- Hoon uses significant whitespace. 
            
            :: Feel free to cut and paste the following expression into the dojo, starting with =c:

                =c |%
                ++  twenty  20
                ++  double-twenty  (mul 2 twenty)
                --

            :: This core has two arms, twenty and double-twenty. 
            
            :: Each arm definition begins with ++ followed by the name of that arm. 
            
            :: After that is the Hoon expression associated with that arm. 
            
            :: The first expression is the trivial 20 (guess what that does?), and the second is the slightly more interesting (mul 2 twenty).

                twenty.c
                :: 20

                double-twenty.c
                :: 40

                (mul 2 double-twenty.c)
                :: 80


            :: the second arm, double-twenty, makes use of the first arm, twenty. It's able to do so because each arm is evaluated with its parent core as the subject. 



        :: |% Expressions

            :: |% indicates the beginning of an expression that produces a core. 
            
            :: The ++ rune is used to define each of the arms of the core's battery, and is followed by both an arm name and a Hoon expression. 
            
            :: The -- rune is used to indicate that there are no more arms to be defined, and indicates the end of the expression.

            
            :: The battery of the core to be produced is explicitly defined by the |% expression. 
            
            :: The payload of the core to be produced is implicitly defined as the subject of the |% expression.




    :: Cores

        :: As stated before, a core is a cell of a battery and a payload.

        :: A core:  [battery payload]



        :: Battery

            :: A battery is a collection of arms. 
            
            :: An arm is an encoded Hoon expression, to be used for running computations. Each arm has a name. 
            
            :: Arm naming rules are the same kebab-case rules that faces have. When an arm is evaluated, it uses its parent core as the subject.

            :: technically a battery is a tree of Nock formulas, one formula per each arm.



        :: Payload

            :: The payload contains all the data needed for running the arms in the battery correctly. 
            
            :: In principle, the payload of a core can have data arranged in any arbitrary configuration. In practice, the payload often has a predictable structure of its own.

            :: (!) The payload may include other cores (!) 
            
            :: Consequently, a core's payload can include other 'code' -- cores in the payload have their own battery arms. ie nested cores.


        
        :: Subject Organization for Arm Computation

            :: Arms can only access data in the subject.
            
            :: By requiring that the parent core be the subject we guarantee that each arm has the appropriate data available to it. 
            
            :: The tail of its subject contains the payload and thus all the values therein. 
            
            :: The head of the subject is the battery, which allows for making reference to sibling arms of that same core.





    :: Another Example Core

        =a 12

        =b [22 24]

        ::  then bind c to a core:

        =c |%
        ++  two  2
        ++  inc  (add 1 a)
        ++  double  (mul 2 a)
        ++  sum  (add -.b +.b)
        --


        :: The |% expression above creates a core with four arms. 
        
        :: The first, named two, evaluates to the constant 2.
        
        :: The second arm, inc, adds 1 to a. 
        
        :: 'double' returns double the value of a, and sum returns the sum of the two atoms in b. 


        :: (!) a wing resolution to a leg returns the value of that leg. A wing resolution to an arm returns the value produced by the arm computation (!)




    :: Dissecting a Core

        :: Enter c in the dojo to look at this core as printed data:

            :: > c
            :: < 4.cvq
            ::     { {{a/@ud b/{@ud @ud}} our/@p now/@da eny/@uvJ}
            ::         <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
            ::     }
            :: >

            :: c, like all cores, is a cell of [battery payload], and it's pretty-printed inside a set of angled brackets: < >. 
            
            :: The battery of four arms is represented by the pretty-printer as 4.cvq. 
            
            :: The 4 represents the number of arms in the battery, and the cvq is a hash of the battery.



            :: The tail, i.e., the payload, might look suspiciously familiar. It looks an awful lot like the default dojo subject, which has our, now, and eny in the head, but it also has a and b, which we also bound in the dojo subject. 
            
            :: That's exactly what the payload is. The tail is a copy of what the subject was for the |% expression. (It's pretty-printed in a slightly compressed way).

            :: You'll notice that there are several other cores in the payload. For example, 19.anu is a battery of 19 arms, 24.tmo is a battery of 24 arms, etc.



            :: This means, among other things, that we should be able to unbind a and b in the subject, but the arms of c should still work correctly:

                =a

                =b

                a
                :: -find.a

                b
                :: -find.b

                double.c
                :: 24

                sum.c
                :: 46


                :: This works because a and b were copied into the core payload when the core was initially created. Unbinding them in the dojo subject doesn't matter to the arms in c, which only look in c's payload anyway.

                :: The payload stores all the data needed to compute the arms correctly. 
                
                :: That also includes add and mul, which themselves are arms in a core of the Hoon standard library. This library core is available as part of the default dojo subject.





    :: Wings that Resolve to Arms

        :: Remember that face resolution to a leg of the subject produces the leg value unchanged, but resolution to an arm produces the computed value of that arm.




        :: Address-Based Wings

            :: the following expressions return legs based on an address in the subject: +n, ., -, +, +>, +<, ->, -<, &, | etc. 
            
            :: When these resolve to the part of the subject containing an arm, they don't evaluate the arm. They simply return the indicated noun fragment of the subject, as if it were a leg.

            :: Let's use -.c to look at the head of c, i.e., the battery of the core:

                -.c
                :: [ [1 2]
                ::     [ [8 [9 702 0 2.047] 9 2 10 [6 [7 [0 3] 1 2] 0 56] 0 2]
                ::         8
                ::         [9 20 0 2.047]
                ::         9
                ::         2
                ::         10
                ::         [6 [7 [0 3] 1 1] 0 56]
                ::         0
                ::         2
                ::     ]
                ::     8
                ::     [9 20 0 2.047]
                ::     9
                ::     2
                ::     10
                ::     [6 [0 114] 0 115]
                ::     0
                ::     2
                :: ]

            :: The result is a tree of uncomputed Nock formulas.

            :: Generally speaking, don't use address-based expressions to look at arms for any reason other than to satisfy your curiosity (and even then only if you've learned or plan to learn Nock). Use name-based expressions instead.


        

        :: Name-based Wings

            :: To get the arm of a core to compute you must use its name. The arm names of c are in the expression used to create c.

            :: You can also evaluate the arms of c using : instead:

                two:c
                :: 2

                inc:c
                :: 13

                double:c
                :: 24

                sum:c
                :: 46


            :: The difference between two.c and two:c is as follows:
            
                :: two.c is an instruction for finding two in c in the subject. 
                
                :: two:c is an instruction for setting c as the subject, and then for finding two. 
                
                :: In the examples above both versions amount to the same thing, and so return the same product.


            

        :: Name Searches and Collisions

            :: It's possible to have 'name collisions' with faces and arm names. 
            
            :: Nothing prevents one from using the name of some arm as a face too. For example:

                double:c
                :: 24

                double:[double=123 c]
                :: 123


            :: When [double=123 c] is the subject, the result is a cell of: 
                
                :: (1) double=123 and 
                :: (2) the core c:

                [double=123 c]
                :: [ double=123
                ::     < 4.cvq
                ::         { {{a/@ud b/{@ud @ud}} our/@p now/@da eny/@uvJ}
                ::         <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
                ::         }
                ::     >
                :: ]

            
            :: Hoon doesn't know whether 'double' is a face or an arm name until it conducts a search looking for name matches. 
            
            :: If it finds a face first, the value of the face is returned. 
            
            :: If it finds an arm first, the arm will be evaluated and the product returned. 
            
            :: You may use ^ to indicate that you want to skip the first match, and multiple ^s to indicate multiple skips:

                double:[double=123 c]
                :: 123

                ^double:[double=123 c]
                :: 24

                ^double:[double=123 double=456 c]
                :: 456

                ^^double:[double=123 double=456 c]
                :: 24




        :: Modifying a Core's Payload

            :: We can produce a modified version of the core c in which a and b have different values. 
            
            :: A core is just a noun in the subject, so we can modify it in the way we learned to modify legs in the last lesson. 
            
            :: To change a to 99, use c(a 99):

                c(a 99)
                :: < 4.cvq
                ::     { {{a/@ud b/{@ud @ud}} our/@p now/@da eny/@uvJ}
                ::         <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
                ::     }
                :: >

                a.c
                :: 12


            :: The expression c(a 99) produces a core exactly like c except that the value of a in the payload is 99 instead of 12. 
            
            :: But when we evaluate a.c we still get the original value, 12. Why? 
            
            :: The value of c in the dojo is bound to the original core value, and will stay that way until we unbind c or bind it to something else. 
            
            :: We can ask for a modified copy of c but that value doesn't automatically persist. It must be put into the subject if we're to find it there. 
            

            :: So how do we know that c(a 99) successfully modified the value of a? We can check by setting the new version of the core as the subject and checking a:

                a:c(a 99)
                :: 99

                double:c(a 99)
                :: 198



            :: To make the modified core persist as c, we can rebind c to the new value:

                =c c(a 99)

                a:c
                :: 99

                double:c
                :: 198


            :: We can make multiple changes to c at once:

                =c c(a 123, b [44 55])

                a:c
                :: 123

                b:c
                :: [44 55]

                two:c
                :: 2

                inc:c
                :: 124

                double:c
                :: 246

                sum:c
                99


!:

:: Doors

    :: It's useful to have cores whose arms evaluate to make gates. 
    
    :: The use of such cores is common in Hoon; that's how the functions of the Hoon standard library are stored in the subject. 

    :: In this lesson you'll also learn about a new kind of core, called a 'door'.



    :: Two Kinds of Function Calls

        :: There are two ways of making a function call in Hoon. 
        
        :: First, you can call a gate in the subject by name. This is what you did with inc in the last lesson; you bound inc to a gate that adds 1 to an input:

            =inc |=(a=@ (add 1 a))

            (inc 10)
            :: 11

        
        :: The second way of making a function call involves an expression that produces a gate:

            (|=(a=@ (add 1 a)) 123)
            :: 124

            (|=(a=@ (mul 2 a)) 123)
            :: 246


        :: The difference is that inc is an already-created gate in the subject when we called it. The latter calls involve producing a gate that doesn't exist anywhere in the subject, and then calling it.


        :: Are calls to add and mul of the Hoon standard library of the first kind, or the second?

            (add 12 23)
            :: 35

            (mul 12 23)
            :: 276

                :: A: the second, since the subject name exists in the standard library already

        :: They're of the second kind. Neither add nor mul resolves to a gate directly; they're each arms that produce gates.


        :: For certain use cases you'll want the extra flexibility that comes with having an already produced core in the subject.




    :: A Gate-Building Core

        :: Let's make a core with arms that build gates of various kinds. As we did in a previous lesson, we'll use the |% rune.

            =c |%
            ++  inc  |=(a=@ (add 1 a))
            ++  add-two  |=(a=@ (inc (inc a)))
            ++  double  |=(a=@ (mul 2 a))
            ++  triple  |=(a=@ (mul 3 a))
            --

        :: Let's try out these arms, using them for function calls:

            (inc:c 10)
            :: 11

            (add-two:c 10)
            :: 12

            (double:c 10)
            :: 20

            (triple:c 10)
            :: 30

            (triple:c (double:c 1))
            :: 6

        :: Notice that each arm in core c is able to call the other arms of c -- add-two uses the inc arm to increment a number twice. 
        
        :: As a reminder, each arm is evaluated with its parent core as the subject. In the case of add-two the parent core is c, which has inc in it.



        :: Mutating a Gate

            :: Let's say you want to modify the default sample of the gate for double. We can infer the default sample by calling double with no argument:

            (double:c)
            :: 0

            :: Given that a x 2 = 0, a must be 0. (Remember that a is the face for the double sample, as defined in the core we bound to c above.)



            :: Let's say we want to mutate the double gate so that the default sample is 25. There is only one problem: double isn't a gate!

                double.c(a 25)
                :: -tack.a
                :: -find.a

            :: It's an arm that produces a gate, and a cannot be found in double until the gate is created. 
            
            :: Furthermore, every time the gate is created, it has the default sample, 0. 
            
            :: If you want to mutate the gate produced by double, you'll first have to put a copy of that gate into the subject:

                =double-copy double:c

                (double-copy 123)
                :: 246

            :: Now let's mutate the sample to 25, and check that it worked with +6:

                +6:double-copy(a 25)
                :: a=25

            :: Good. Let's call it with no argument and see if it returns double the value of the modified sample.

                (double-copy(a 25))
                :: 50

            :: It does indeed!


            :: Contrast this with the behavior of add. We can look at the sample of the gate for add with +6:add:

                +6:add
                :: [a=0 b=0]

            :: If you try to mutate the default sample of add, it won't work:

                add(a 3)
                :: -tack.a
                :: -find.a

            :: As before with double, Hoon can't find an a to modify in a gate that doesn't exist yet.




    :: Other Functions in the Hoon Standard Library

        :: Let's look once more at the parent core of the add arm in the Hoon standard library:

            ..add
            :: <74.dbd 1.qct $141>

        :: The battery of this core contains 74 arms, each of which evaluates to a gate in the standard library. 
        
        :: This 'library' is nothing more than a core containing useful basic functions that Hoon often makes available as part of the subject. 
        
        :: You can see the Hoon code defining these arms near the beginning of hoon.hoon, starting with ++ add. (Yes, the Hoon standard library is written in Hoon.)




    :: Doors

        :: A brief review: 
        
            :: A core is a cell of battery and payload: [battery payload]. 
            
            :: The battery is code and the payload is data. 
            
            :: The battery contains a series of arms, and 
            
            :: the payload contains all the data necessary to run those arms correctly.


        :: New material: 
            
            :: A door is a core with a sample. 
            
            :: That is, a door is a core whose payload is a cell of sample and context: [sample context].

            ::         Door
            ::        /    \
            :: Battery      .
            ::             / \
            ::       Sample   Context


            :: It follows from this definition that a gate is a special case of a door. 
            
            :: (!) A gate is a door with exactly one arm, named $ (!)


            :: Gates are useful for defining functions. 
            
            :: But there are many-armed doors as well. 
            
            :: How are they used? 
            
                :: Doors are quite useful data structures. In Chapter 2 of the Hoon tutorial series you'll learn how to use doors to implement state machines, where the sample stores the relevant state data.



        :: An Example Door

            




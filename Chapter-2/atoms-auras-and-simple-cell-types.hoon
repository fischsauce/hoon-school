!:

:: Atoms, Auras, and Simple Cell Types

    :: A type is ordinarily understood to be a set of values. Examples: the set of all atoms is a type, the set of all cells is a type, and so on.

    :: Type systems provide type safety, in part by making sure functions produce values of the correct type.
    
    :: When you write a function whose product is intended to be an atom, it would be nice to know that the function is guaranteed to produce an atom. 
    
    :: Hoon's type system provides such guarantees with TYPE CHECKING and TYPE INFERENCE.



    :: In order to have a solid foundational knowledge of Hoon's type system, you must understand: 

        :: (1) precisely what kind of information is tracked by Hoon's type system, 
        
        :: (2) what a type check is and where they occur, 
        
        :: (3) what type inference is and how it works, and 
        
        :: (4) how to build your own custom types.





    :: Atoms and Auras

        :: In the most straightforward sense, atoms simply are unsigned integers. But they can also be interpreted as representing signed integers, ASCII symbols, floating-point values, dates, binary numbers, hexadecimal numbers, and more. 
        
        :: Every atom is, in and of itself, just an unsigned integer; but Hoon keeps track of type information about each atom, and this info tells Hoon how to interpret the atom in question.


        :: The piece of type information that determines how Hoon interprets an atom is called an aura.


        :: The set of all atoms is indicated with the symbol @

        :: An aura is indicated with @ followed by some letters, e.g., @ud for unsigned decimal. 

        :: Accordingly, the Hoon type system does more than track sets of values. It also tracks certain other relevant metadata about how those values are to be interpreted.



        :: How is aura information generated so that it can be tracked? 
        
            :: One way involves TYPE INFERENCE. 
            
            :: In certain cases Hoon's type system can infer the type of an expression using syntactic clues.
            
            :: In the most straightforward case of type inference, the expression is simply data as a literal. Hoon recognizes the aura literal syntax and infers that the data in question is an atom with the aura associated with that syntax.



            :: (!) To see the INFERRED TYPE of a literal expression in the dojo, use the ? operator. (Note: this operator isn't part of the Hoon programming language; it's a dojo-only tool) (!)

                15
                :: 15

                ? 15
                :: @ud
                :: 15

            :: The @ud is the inferred type of 15 (and of course 15 is the product). The @ is for 'atom' and the ud is for 'unsigned decimal'. The letters after the @ indicate the 'aura' of the atom.



            :: One important role played by the type system is to make sure that the output of an expression is of the intended data type.

            :: One important role played by the type system is to make sure that the output of an expression is of the intended data type.


            :: The programmer must specify this explicitly by using a 'cast'. 
            
                :: (!) To cast for an unsigned decimal atom, you can use the ^- rune along with the @ud from above (!)

            :: What exactly does the ^- rune do? It compares the inferred type of some expression with the desired cast type. 
            
            :: If the expression's inferred type 'nests' under the desired type, then the product of the expression is returned.

            :: Let's try one in the dojo. For the expression to be assessed we'll use 15 again:

                ^-(@ud 15)
                :: 15

            :: Because @ud is the inferred type of 15, the cast succeeds. 
            
            :: Notice that the ^- expression never does anything to modify the underlying noun of the second subexpression. It's used simply to mandate a type-check on that expression. This check occurs at compile-time (i.e., when the expression is compiled to Nock).




            :: What about when the inferred type doesn't fit under the cast type? You get a nest-fail crash at compile-time:

                ^-(@ud [13 14])
                :: nest-fail
                :: [crash message]

            :: Why 'nest-fail'? 
                
            :: The inferred type of [13 14] doesn't 'nest' under the cast type @ud. It's a cell, not an atom. But if we use the symbol for nouns, *, then the cast succeeds:

                ^-(* [13 14])
                :: [13 14]

            :: (!) A cell of atoms is a noun (!)
            
            :: so the inferred type of [13 14] nests under *. 
            
            :: (!) Every product of a Hoon expression nests under * because every product is a noun (!)





    :: What Auras are there?

        :: Hoon has a wide (but not extensible) variety of atom literal syntaxes. 
        
        :: Each literal syntax indicates to the Hoon type checker which predefined aura is intended. Hoon can also pretty-print any aura literal it can parse. 
        
        :: Because atoms make great path nodes and paths make great URLs, all regular atom literal syntaxes use only URL-safe characters.



        :: Here's a non-exhaustive list of auras, along with examples of corresponding literal syntax:


            :: Aura         Meaning                        Example Literal Syntax
            :: ---------------------------------------------------------------------
            :: @d           date
            ::   @da        absolute date                  ~2018.5.14..22.31.46..1435
            ::   @dr        relative date (ie, timespan)   ~h5.m30.s12
            :: @n           nil                            ~
            :: @p           phonemic base (ship name)      ~sorreg-namtyv
            :: @r           IEEE floating-point
            ::   @rd        double precision  (64 bits)    .~6.02214085774e23
            ::   @rh        half precision (16 bits)       .~~3.14
            ::   @rq        quad precision (128 bits)      .~~~6.02214085774e23
            ::   @rs        single precision (32 bits)     .6.022141e23
            :: @s           signed integer, sign bit low
            ::   @sb        signed binary                  --0b11.1000
            ::   @sd        signed decimal                 --1.000.056
            ::   @sv        signed base32                  -0v1df64.49beg
            ::   @sw        signed base64                  --0wbnC.8haTg
            ::   @sx        signed hexadecimal             -0x5f5.e138
            :: @t           UTF-8 text (cord)              'howdy'
            ::   @ta        ASCII text (knot)              ~.howdy
            ::     @tas     ASCII text symbol (term)       %howdy
            :: @u              unsigned integer
            ::   @ub           unsigned binary             0b11.1000
            ::   @ud           unsigned decimal            1.000.056
            ::   @uv           unsigned base32             0v1df64.49beg
            ::   @uw           unsigned base64             0wbnC.8haTg
            ::   @ux           unsigned hexadecimal        0x5f5.e138


        :: Some of these auras nest under others. For example, @u is for all unsigned auras. But there are other, more specific auras; @ub for unsigned binary numbers, @ux for unsigned hexadecimal numbers, etc.





    :: Aura Inference in Hoon

        :: Let's do more examples in the Dojo using the ? operator. We'll focus on just the unsigned auras for now:

        :: When you enter just 15, the Hoon type checker infers from the syntax that its aura is @ud because you typed an unsigned integer in decimal notation:

            15
            :: 15

        :: Hence, when you use ? to check the aura, you get @ud:

            ? 15
            :: @ud
            :: 15

        :: And when you enter 0x15 the type checker infers that its aura is @ux, because you used 0x before the number to indicate the unsigned hexadecimal literal syntax:

            0x15
            :: 0x15

            ? 0x15
            :: @ux
            :: 0x15

        ::  In both cases, Hoon pretty-prints the appropriate literal syntax by using inferred type information from the input expression; the Dojo isn't (just) echoing what you enter.





        :: More generally: for each atom expression in Hoon, you can use the literal syntax of an aura to force Hoon to interpret the atom as having that aura type. For example, when you type ~sorreg-namtyv Hoon will interpret it as an atom with aura @p and treat it accordingly.


            :: Here's another example of type inference at work:

                (add 15 15)
                :: 30

                ? (add 15 15)
                :: @
                :: 30

                (add 0x15 15)
                :: 36

                ? (add 0x15 15)
                :: @
                :: 36


        :: (!) The add function in the Hoon standard library operates on all atoms, regardless of aura, and returns atoms with no aura specified (!)


        :: Hoon isn't able to infer anything more specific than @ for the product of add. This is by design, however. Notice that when you add a decimal and a hexadecimal above, the correct answer is returned (pretty-printed as a decimal). 
        
            :: This works for all of the unsigned auras:

                (add 100 0b101)
                :: 105

                (add 100 0xf)
                :: 115

                (add 0b1101 0x11)
                :: 30


        :: The reason these add up correctly is that unsigned auras all map directly to the 'correct' atom underneath. 
        
        :: For example, 16, 0b1.0000, and 0x10 are all the exact same atom, just with different literal syntax. (This doesn't hold for signed versions of the auras!)

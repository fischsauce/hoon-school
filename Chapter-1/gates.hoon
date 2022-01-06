:: Output value(s) that depend solely upon input value(s) is an important property of functions. ie REFERENCIAL TRANSPARENCY -- "An expression is called referentially transparent if it can be replaced with its corresponding value (and vice-versa) without changing the program's behavior."


:: What is a Gate?


:: A CORE is a cell: [battery payload].

:: A GATE is a core with two distinctive properties:


    :: (1) the BATTERY of a gate contains exactly one arm, which has the special name $ (buc). 

        :: The $ arm contains the instructions for the function in question.
        

    :: (2), the PAYLOAD of a gate consists of a cell of [sample context]. 
        
        :: The SAMPLE is the part of the payload that stores the "argument" (i.e., input value) of the function call. 
        
        :: The CONTEXT contains all other data that is needed for computing the $ arm of the gate correctly.

    :: eg:
    :: [$ [Sample Context]]

    :: As a tree, a gate looks like the following:

        ::    Gate
        ::   /    \
        ::  $      .
        ::        / \
        ::  Sample   Context

    :: $ is computed with its parent core as the subject. When $ is computed, the resulting value is called the "product" of the gate




:: The |= (bar-tis) Rune

    :: We typically use the |= rune to create a gate.

    :: Let's make a gate that takes any unsigned integer (i.e., an atom) as its sample and returns that value plus one as the product. To do this we'll use the |= (bar-tis) rune. We'll bind this gate to the face inc for "increment":

    =inc |=(a=@ (add 1 a))

    :: |= is immediately followed by a set of parentheses containing two subexpressions: 

    a=@ :: and 
    (add 1 a)

    :: The first defines the gate's sample (input value type), and the second defines the gate's product (value).


    =inc
    :: inc, the sample is defined by a=@. This means that the sample is defined as an atom, @, meaning that the gate will take as input anything of that type.


    :: In inc, the product is defined by (add 1 a). There's not much to it -- it returns the value of a+1!

    :: The second subexpression after the |= rune is used to build the gate's $ arm. That's where all the computations go.




:: Anatomy of a Gate

    :: A gate is a one-armed core with a sample: 
    
    [$ [Sample Context]]

    inc
    :: < 1.jgn
    ::  { a/@
    ::     {our/@p now/@da eny/@uvJ}
    ::     <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
    ::  }
    :: >



    :: The $ Arm

        :: The $ (buc) Arm of a gate encodes the instructions for the Hoon function in question.

        :: The pretty printer represents the $ arm of inc as 1.jgn. To see the actual noun of the $ arm, enter +2:inc into the Dojo:

        +2:inc
        :: [8 [9 8 0 4.095] 9 2 [0 4] [[7 [0 3] 1 1] 0 14] 0 11]

        :: This is un-computed Nock. You don't need to understand any of this.


        :: It's worth pointing out that the arm name, $, can be used like any other name. We can compute $ directly with $:inc in the Dojo:

        $:inc
        :: 1

            :: We didn't call inc or in any other way pass it a number. Yet using $ to evaluate inc's arm seems to work. Why is it so?



    :: The Sample

        :: The sample of a gate is the address reserved for storing the argument(s) to the Hoon function. The sample is always at the head of the gate's tail, i.e., +6

        inc
        :: < 1.jgn
        :: { a/@
        ::     {our/@p now/@da eny/@uvJ}
        ::     <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
        :: }
        :: >

        :: We see a/@. This may not be totally clear, but it should make some sense. This is the pretty-printer's way of indicating an atom with the face a. Let's take a closer look:

        :: The sample of inc is the value 0, and has a as a face:

        +6:inc
        :: a=0

        ::  If you evaluate the $ arm of inc without passing it an argument the placeholder value is used for the computation, and the return value will thus be 0+1:

        $:inc
        :: 1

        :: The placeholder value is sometimes called a BUNT value. The bunt value is determined by the input type; FOR ATOMS -- @, THE BUNT VALUE IS 0.



    :: The Context

        :: The context of a gate contains other data that may be necessary for the $ arm to evaluate correctly. 
        
        :: The context is always located at the tail of the tail of the gate, i.e., +7 of the gate.

        +7:inc
        :: [ [ our=~zod
        ::     now=~2018.12.12..18.55.06..df2b
        ::     eny
        ::     \/0v2g0.cmm6d.1igpo.llg7o.4921d.nov38.vjsgp.mdfln.8pt9f.n23hj.qc6q9.8p7bd\/
        ::     .2eo59.qko43.1jgd2.rtc44.egooe.esvft.orohc.i9ufn.4rnur
        ::     \/                                                                       \/
        :: ]
        :: <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
        :: ]

        :: This is exactly the default Dojo subject, from before we put inc into the subject. 
        
        :: The |= expression defines the context as whatever the subject is. 
        
        :: This guarantees that the context has all the information it needs to have for the $ arm to work correctly.


    
    :: Exercise 1.4.1a
    
        :: Write a gate that takes an atom, a=@, and which returns double the value of a. Bind this gate to double and test it in the Dojo. A solution is given at the end of this lesson.

        =double |=(a=@ (mul a 2))




:: Gates Define Functions of the SAMPLE

    :: In Hoon, one can use (gate arg) syntax to make a function call. For example:

        (inc 234)
        :: 235

        (double 314.159)
        :: 628.318

        :: When a function call occurs, A COPY OF THE GATE IS CREATED, but with one modification; THE SAMPLE IS REPLACED WITH THE FUNCTION ARGUMENT. 
        
        :: Then the $ arm is computed against this modified version of the inc gate.

        :: Neither the arm nor the context is modified before the arm is evaluated. -- the only part of the gate that changes before the arm evaluation is the sample.


        :: Let's unbind inc to keep the subject tidy:
        =inc

        inc
        :: -find.inc (expression fails)




:: Modifying the CONTEXT of a GATE

    :: It is possible to modify the context of a gate when you make a function call.

    :: Let's write a gate which uses a value from the context to generate the product. Bind b to the value 10:

    =b 10

    b
    :: 10


    :: Now let's write a gate called ten that adds b to the input value:

    =ten |=(a=@ (add a b))

    (ten 10)
    :: 20


    :: We can unbind b from the Dojo subject, and ten works just as well because it's using a copy of b stored its context:

    =b

    (ten 15)
    :: 25


    :: We can use ten(b 25) to produce a variant of ten. Calling this mutant version of ten causes a different value to be returned than we'd get with a normal ten call:

    (ten(b 25) 10)
    :: 35


    






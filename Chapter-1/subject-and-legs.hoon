!:

:: 1.6 The Subject and Its Legs

    :: we can say three things about the subject: 
    
        :: (1) every Hoon expression is evaluated relative to some subject; 
        
        :: (2) roughly, the subject defines the environment in which a Hoon expression is evaluated; and 
        
        :: (3) the subject is a noun.


    +3:[[11 22] 33]
    :: 33

    :: The : operator does two things. First, it evaluates the expression on the right-hand side; and second, it evaluates the expression on the left-hand side, using the product of the right-hand side as its subject.

    :: the expression on the right-hand, [[11 22] 33], evaluates to itself, so the subject for the left-hand expression, +1, is simply [[11 22] 33]



    :: Let's create a subject with some computations:
    
        [[(add 22 33) (mul 2 6)] 23]
        :: [[55 12] 23]

        +1:[[(add 22 33) (mul 2 6)] 23]
        :: [[55 12] 23]

        +2:[[(add 22 33) (mul 2 6)] 23]
        :: [55 12]

        +3:[[(add 22 33) (mul 2 6)] 23]
        :: 23

        +4:[[(add 22 33) (mul 2 6)] 23]
        :: 55


    :: Limbs of the Subject

        :: The subject is a noun, just like any other piece of Hoon data. In Lesson 1.2 we discussed how any noun can be understood as a binary tree. E.g., [[4 5] [6 [14 15]]]:

            :: [[4 5] [6 [14 15]]]
            ::      .
            ::     / \
            ::   .     .
            ::  / \   / \
            :: 4   5 6    .
            ::           / \
            ::          14 15


            :: Each fragment of a noun is itself a noun, and hence can be understood as a binary tree as well. 
            
            :: Each fragment or 'subtree' sticks out of the original tree, like a limb. 
            
            :: (!) A LIMB IS A SUBTREE OF THE SUBJECT (!)



        :: There are TWO KINDS OF LIMBS to accommodate these two cases: ARMS and LEGS.

            :: ARMS are limbs of the subject that are used for carrying out substantive computations. We'll talk about arms in the next lesson. 
            
            :: LEGS are limbs that store data. 
            
            :: (!) ANY LIMB THAT ISN'T AN ARM IS A LEG (!)

        

        :: Address-based Limb Expressions

            :: A limb expression is an expression of Hoon that resolves to a limb of the subject. 
            
            :: An ADDRESS-BASED LIMB EXPRESSION evaluates to a limb of the subject based on its noun address.


            :: the limb expressions that return a leg according to subject address:


                :: + Operator

                    :: For any unsigned integer n, +n returns the limb of the subject at address n. If there is no such limb, the result is a crash.

                    +2:[111 222 333]
                    :: 111

                    +3:[111 222 333]
                    :: [222 333]

                    +6:[111 222 333]
                    :: 222



                :: . expression

                    :: Using . as an expression returns the entire subject. It's equivalent to +1.

                    .:[[4 5] [6 [14 15]]]
                    :: [[4 5] 6 14 15]

                    .:[4 5]
                    :: [4 5]

                    .:'The whole subject!'
                    :: 'The whole subject!'



                :: 'lark' expressions (+, -, +>, +<, ->, -<, etc.)

                    :: Using - by itself returns the head of the subject, and using + by itself returns the tail:

                    -:[[4 5] [6 [14 15]]]
                    :: [4 5]

                    +:[[4 5] [6 [14 15]]]
                    :: [6 14 15]

                    :: To think of it another way, - is for the left and + is for the right.


                    :: (!) - and + only work if the subject is a cell, naturally. An atom doesn't have a head or a tail. (!)



                    :: What if you want the tail of the tail of the subject? You might expect that you can double up on + for this: ++. Not so. Instead, combine + with >: +>. > means the same thing as +, but is used with + to make for easier reading.

                    :: > means the same thing as +, but is used with + to make for easier reading.

                    :: -< returns the head of the head; -> returns the tail of the head; and +< returns the head of the tail.

                    -<:[[4 5] [6 [14 15]]]
                    :: 4

                    ->:[[4 5] [6 [14 15]]]
                    :: 5

                    +<:[[4 5] [6 [14 15]]]
                    :: 6

                    +>:[[4 5] [6 [14 15]]]
                    :: [14 15]

                    By alternating the +/- symbols with </> symbols, you can grab an even more specific limb of the subject:

                    +>-:[[4 5] [6 [14 15]]]
                    :: 14

                    +>+:[[4 5] [6 [14 15]]]
                    :: 15


                    :: In the case of +>-< this path is: tail, tail, head, head:

                        ::     *Root*
                        ::     /    \
                        :: Head   *Tail*
                        ::         /    \
                        ::     Head   *Tail*
                        ::             /    \
                        ::         *Head*   Tail
                        ::         /    \
                        ::     *Head*   Tail



                    :: Exercise 1.6a -- 
                    
                        :: 1. Use a lark expression to obtain the value 6 in the following noun represented by a binary tree:

                        ::          .
                        ::          /\
                        ::         /  \
                        ::        /    \
                        ::       .      .
                        ::      / \    / \
                        ::     /   .  10  .
                        ::    /   / \    / \
                        ::   .   8   9  11  .
                        ::  / \            / \
                        :: 5   .          12  13
                        ::    / \
                        ::  *6   7

                        [[[[5 [6 7]] 8 9]]   [10 [11 [12 13]]]]

                        -<+<:[[[[5 [6 7]] 8 9]] [10 [11 [12 13]]]]
                        :: 6        o



                        :: 2. Use a lark expression to obtain the value 9 in the following noun: [[5 6] 7 [[8 9 10] 3] 2].

                        +>-<+<:[[5 6] 7 [[8 9 10] 3] 2]
                        :: 9        o




                :: & and | operators

                    :: &n returns the nth item of a list that has at least n + 1 items. 
                    
                    :: |n returns everything after &n.

                    :: There are two kinds of lists: empty and non-empty. 
                    
                    :: The empty list is null, ~. 
                    
                    :: A non-empty list is a cell whose head is the first item and whose tail is the rest of the list. 
                    
                    :: 'The rest of the list' is itself a list. 
                    
                    :: Hoon lists are null-terminated; that is, the null symbol ~ indicates the end of the list. 
                    
                    
                    :: Consider the following cell of nouns:

                            ['first' 'second' 'third' 'fourth' ~]
                            :: ['first' 'second' 'third' 'fourth' ~]

                        :: The 'first' noun is at +2, 'second' is at +6, 'third' is at +14, and so on. (Try it!) That's because the above noun is really the following:

                            ['first' ['second' ['third' ['fourth' ~]]]]
                            :: ['first' 'second' 'third' 'fourth' ~]


                        :: Rather than using +2 to produce 'first' and +6 to produce 'second', 
                        
                        :: (!) you can use &1 and &2 to produce the first and second items in the list, respectively (!):

                            &1:['first' 'second' 'third' 'fourth' ~]
                            :: 'first'

                            &2:['first' 'second' 'third' 'fourth' ~]
                            :: 'second'


                        :: The list items can themselves be cells:

                            &1:[['first' %pair] ['second' %pair] ['third' %pair] ~]
                            :: ['first' %pair]
                    


                        :: We can give an alternate, recursive definition of &n for all positive integers n. In the base case, &1 is equivalent to +2. 
                        
                        :: For the generating case, assume that &(n - 1) is equivalent to +k. Then &n is equivalent to +((k × 2) + 2).

                        :: For example, let n be 4. What is &4? &3 is equivalent to +14. (14 × 2) + 2 is 30, so &4 is equivalent to +30.



                    :: |n returns the rest of the list after &n: 

                        |1:['first' 'second' 'third' 'fourth' ~]
                        :: ['second' 'third' 'fourth' ~]

                        |2:['first' 'second' 'third' 'fourth' ~]
                        :: ['third' 'fourth' ~]


                        :: we can characterize |n recursively. In the base case, |1 is +3. 
                        
                        :: In the generating case, assume that |(n - 1) is equivalent to +k. Then |n is equivalent to +((k × 2) + 1).





        :: Other Limb Expressions: Names

            :: A name can resolve either an arm or a leg of the subject. 
            
            :: ARMS are for COMPUTATIONS and LEGS are for DATA. 
            
            :: When a name resolves to an arm, the relevant computation is run and the product of the computation is produced. 
            
            :: When a limb name resolves to a leg, the value of that leg is produced.



            :: Faces

                :: Hoon doesn't have variables like other programming languages do; it has 'faces'.

                :: most frequently faces are used simply as labels for legs.

                :: A face has a combination of lowercase letters, numbers, and the - character. Some example faces: b, c3, var, this-is-kebab-case123. 
                
                :: (!) Faces must begin with a letter. (!)

                ::  for now we'll use the simplest method: face=value:

                    b=5
                    :: b=5

                    [b=5 cat=6]
                    :: [b=5 cat=6]

                    -:[b=5 cat=6]
                    :: b=5

                    b:[b=5 cat=6]
                    :: 5

                    b2:[[4 b2=5] [cat=6 d=[14 15]]]
                    :: 5

                    d:[[4 b2=5] [cat=6 d=[14 15]]]
                    :: [14 15]

                    :: The faces are not part of the underlying noun; they're stored as metadata about address values in the subject.


                    :: If you use a face that isn't in the subject you'll get a find.[face] crash:

                        a:[b=12 c=14]
                        :: -find.a
                        :: [crash message]


                    :: You can give your faces faces:

                        b:[b=c=123 d=456]
                        :: c=123

                
                :: Duplicate Faces

                    :: There is no restriction against using the same face name for multiple limbs of the subject. This is one way in which faces aren't like ordinary variables:

                        [[4 b=5] [b=6 b=[14 15]]]
                        :: [[4 b=5] b=6 b=[14 15]]

                        b:[[4 b=5] [b=6 b=[14 15]]]
                        :: 5

                        :: Why does this return 5 rather than 6 or [14 15]? 
                        
                        :: When a face is evaluated on a subject, a head-first binary tree search occurs starting at address 1 of the subject. 
                        
                        :: If there is no matching face for address n of the subject, first the head of n is searched and then n's tail. 
                        
                        :: The complete search path for [[4 b=5] [b=6 b=[14 15]]] is:

                            :: [[4 b=5] [b=6 b=[14 15]]]
                            :: [4 b=5]
                            :: 4
                            :: b=5
                            :: [b=6 b=[14 15]]
                            :: b=6
                            :: b=[14 15]

                            :: There are matches at steps 4, 6, and 7 of the total search path, but the search ends when the first match is found at step 4.

                        :: The children of legs bearing names aren't included in the search path. For example, the search path of:

                            :: [[4 a=5] b=[c=14 15]]

                            :: [4 a=5]
                            :: 4
                            :: a=5
                            :: b=[c=14 15]

                            :: Neither of the legs c=14 or 15 is checked. Accordingly, a search for c of [[4 a=5] b=[c=14 15]] fails:

                                c:[[4 b=5] [b=6 b=[c=14 15]]]
                                :: -find.c [crash message]



                :: Skipping Faces
                
                    :: You can 'skip' the first match by prepending ^ to the face. 

                    :: Upon discovery of the first match at address n, the search skips n (as well as its children) and continues the search elsewhere:

                        ^b:[[4 b=5] [b=6 b=[14 15]]]
                        :: 6

                        :: the search path for this noun is:

                            :: [[4 b=5] [b=6 b=[14 15]]]
                            :: [4 b=5]
                            :: 4
                            :: b=5
                            :: [b=6 b=[14 15]]
                            :: b=6
                            :: b=[14 15]

                        :: The second match in the search path is step 6, b=6, so the value at that leg is produced. 
                        
                        
                    :: You can stack ^ characters to skip more than one matching face:

                        a:[[[a=1 a=2] a=3] a=4]
                        :: 1

                        ^a:[[[a=1 a=2] a=3] a=4]
                        :: 2

                        ^^a:[[[a=1 a=2] a=3] a=4]
                        :: 3


                    :: When a face is skipped at some address n, neither the head nor the tail of n is searched:

                        b:[b=[a=1 b=2 c=3] a=11]
                        :: [a=1 b=2 c=3]

                        ^b:[b=[a=1 b=2 c=3] a=11]
                        :: -find.^b
                        :: ERROR




    :: Wings


        :: A wing is a limb resolution path into the subject. 
        
        :: A wing expression indicates the path as a series of limb expressions separated by the . character. E.g.,

            :: limb1.limb2.limb3

            :: You can read this as limb1 in limb2 in limb3, etc.

        
        :: You can use a wing to get the value of c in [[4 a=5] b=[c=14 15]]: c.b

            c.b:[[4 a=5] b=[c=14 15]]
            :: 14


        :: And to get the b inside the head of [b=[a=1 b=2 c=3] a=11]: b.b.

            b.b:[b=[a=1 b=2 c=3] a=11]
            :: 2

            a.b:[b=[a=1 b=2 c=3] a=11]
            :: 1

            c.b:[b=[a=1 b=2 c=3] a=11]
            :: 3

            a:[b=[a=1 b=2 c=3] a=11]
            :: 11

            b.a:[b=[a=1 b=2 c=3] a=11]
            :: -find.b.a


        :: Here are some other wing examples:

            g.s:[s=[c=[d=12 e='hello'] g=[h=0xff i=0b11]] r='howdy']
            :: [h=0xff i=0b11]

            c.s:[s=[c=[d=12 e='hello'] g=[h=0xff i=0b11]] r='howdy']
            :: [d=12 e='hello']

            e.c.s:[s=[c=[d=12 e='hello'] g=[h=0xff i=0b11]] r='howdy']
            :: 'hello'

            +3:[s=[c=[d=12 e='hello'] g=[h=0xff i=0b11]] r='howdy']
            :: r='howdy'

            r.+3:[s=[c=[d=12 e='hello'] g=[h=0xff i=0b11]] r='howdy']
            :: 'howdy'




        :: Limbs are Trivial Wings

            :: a wing is a limb resolution path into the subject. 
            
            :: This definition includes as a trivial case a path of just one limb. 
            
            :: (!) all limbs are wings, and all limb expressions are wing expressions (!)

            :: it is convenient to refer to all limbs and non-trivial wings as simply 'wings'. 


    

    :: Exploring the Subject

        :: every Hoon expression is evaluated relative to a subject. 
        
        :: We showed how the : operator uses a Hoon expression on the right-hand side to set the subject for the expression on the left.

            b:[b='Hello world!' c='This is the tail of the subject for the LHS']
            :: 'Hello world!'

            :: The left, b, uses the product of the right as its subject.



            :: what about the right-hand expression? What's its subject?



            :: Usually the subject of a Hoon expression isn't shown explicitly.

                :: Consider the expression (add 2 2):

                    (add 2 2)
                    :: 4

                    :: What's the subject of this expression?




    :: Dojo Faces

        :: The dojo is like a cross between a Lisp REPL and the Unix shell.


        :: You can use the dojo to add a noun with a face to the subject. Type:

            =a 37


        :: Hoon expressions entered into the dojo can now use a and it will resolve to this value. So you can write:

            a
            :: 37

            [4 a]
            :: [4 37]

            (add a a)
            :: 74

            (mul a a)
            :: 1.369

            b=(mul a 3)
            :: 111


        :: To unbind a and remove its value from the subject, enter =a and omit the value:
            
            =a



        :: Dojo Fun

            :: We can use dojo faces to get used to how wings work.





    :: Creating a Modified Leg

        :: there is a way to produce a modified version of the leg as well. To do so, we use an expression of the form:

            :: wing-of-subject(wing-1 new-value-1, wing-2 new-value 2, ...)

            :: The wing-of-subject resolves to some limb in the subject. 
            
            :: This is followed by a set of parentheses. 
            
            :: wing-1 and wing-2 pick out which parts of that limb we want to change. Their values are replaced with new-value-1 and new-value-2, respectively. Commas separate each of the wing new-value pairs.



        :: create a mutant version of the noun we have stored in a. To do this, type in the face a followed by the desired modifications in parentheses:

            a
            :: [g=37 b=[%hi c=.6.28] h=0xdead.beef]

            a(g 44)
            :: [g=44 b=[%hi c=.6.28] h=0xdead.beef]

            a(b 'hello world!')
            :: [g=37 b='hello world!' h=0xdead.beef]

            a(b 'hello world!', h 0xfeed.beef)
            :: [g=37 b='hello world!' h=0xfeed.beef]

            a(b 'hello world!', h 0xfeed.beef, g 123)
            :: [g=123 b='hello world!' h=0xfeed.beef]

            a(+2 r=457.842)
            :: [r=457.842 b=[%hi c=.6.28] h=0xdead.beef]


            :: You can also use more complex wings and modify their values as well:

            b.a(c .3.14)
            :: [%hi c=.3.14]


    
    :: Exercise 1.6b

        :: Enter the following into dojo:

        =a [[[b=%bweh a=%.y c=8] b="no" c="false"] 9]

            :: 1. 
                b:a(a [b=%skrt a="four"])
                :: %skrt        x       %bweh


            :: 2.
                ^b:a(a [b=%skrt a="four"])
                :: %skrt        x       "no"


            :: 3.
                ^^b:a(a [b=%skrt a="four"])
                :: %skrt        x       "-find.^^b"


            :: 4.
                b.a:a(a [b=%skrt a="four"])
                :: %skrt        o   


            :: 5.
                a.a:a(a [b=%skrt a="four"])
                :: [b=%skrt a="four"]       x       "four"


            :: 6.
                +.a:a(a [b=%skrt a="four"])
                :: 9        x       a="four"


            :: 7.
                a:+.a:a(a [b=%skrt a="four"])
                :: "four"      o


            :: 8.
                a(a a)
                :: [[[b=%bweh a=%.y c=8] b="no" c="false"] 9]       x    

                    :: [[[b=%bweh a=[[[b=%bweh a=%.y c=8] b="no" c="false"] 9] c=8] b="no" c="false"] 9]


            :: 9.
                b:-<.a(a a)
                :: %bweh        o


            :: 10. How many times does the atom 9 appear in a(a a(a a))?

                :: a(a a) nests a within itself, returning two 9s total.

                :: a(a a(a a)) will nest this again, returning 2 + 2 = 4

                :: x        9 appears 3 times.

                :: So the mutation of a in the innermost pair is not maintained in the outer pair?
            
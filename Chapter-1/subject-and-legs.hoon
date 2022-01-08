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

            






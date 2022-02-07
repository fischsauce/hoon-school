!:

:: 2.4 Standard Library: Trees, Sets, and Maps

:: Along with lists, the Hoon standard library also supports trees, sets, and maps as data structures. 

    :: A Hoon tree is the data structure for a binary tree. 
    
    :: A Hoon set is the data structure for a set of values. 
    
    :: A Hoon map is the data structure for a set of [key value] pairs.



    :: Trees

        :: We use 'tree' to make a binary tree data structure in Hoon, e.g., (tree @) for a binary tree of atoms.


        :: There are two kinds of tree in Hoon: 
            

            :: (1) the null tree, ~, and 
            

            :: (2) a non-null tree which is a cell with three parts. 
            
                :: Part (i) is the node value, 
                
                :: part (ii) is the left child of the node, and 
                
                :: part (iii) is the right child of the node. 
                
                :: Each child is itself a tree. 
                
                :: The node value has the face 'n', the left child has the face 'l', and the right child has the face 'r'. 
                
                :: The following diagram provides an illustration of a (tree @) (without the faces):

                    ::           12
                    ::         /    \
                    ::       8       14
                    ::     /   \    /   \
                    ::    4     ~  ~     16
                    ::  /  \            /  \
                    :: ~    ~          ~    ~


            :: Hoon supports trees of any type that can be constructed in Hoon, e.g.: (tree @), (tree ^), (tree [@ ?]), etc. 
            
            :: Let's construct the tree in the diagram above in the dojo, casting it accordingly:

                `(tree @)`[12 [8 [4 ~ ~] ~] [14 ~ [16 ~ ~]]]
                :: {4 8 12 14 16}


                :: Notice that we don't have to insert the faces manually; by casting the noun above to a (tree @) Hoon inserts the faces for us. 
                
                :: Let's put this noun in the dojo subject with the face b and pull out the tree at the left child of the 12 node:

                =b `(tree @)`[12 [8 [4 ~ ~] ~] [14 ~ [16 ~ ~]]]

                b
                :: {4 8 12 14 16}

                l.b
                :: -find.l.b
                :: find-fork-d

                :: This didn't work because we haven't first proved to Hoon that b is a non-null tree. A null tree has no 'l' in it, after all. Let's try again, using ?~ to prove that b isn't null. We can also look at 'r' and 'n':

                ?~(b ~ l.b)
                :: {4 8}

                ?~(b ~ r.b)
                :: {14 16}

                ?~(b ~ n.b)
                :: 12



            :: Find and replace

                :: Here's a program that finds and replaces certain atoms in a (tree @):

                    |=  [nedl=@ hay=(tree @) new=@]
                    ^-  (tree @)
                    ?~  hay  ~
                    :+  ?:  =(n.hay nedl)
                        new
                        n.hay
                    $(hay l.hay)
                    $(hay r.hay)

                :: 'nedl' is the atom to be replaced, 'hay' is the tree, and 'new' is the new atom with which to replace 'nedl'

                    b
                    :: {4 8 12 14 16}

                    +findreplacetree [8 b 94]
                    :: {4 94 12 14 16}

                    +findreplacetree [14 b 94]
                    :: {4 8 12 94 16}



    :: Sets

        :: Use 'set' to create a data structure for a set of values, e.g., (set @) for a set of atoms. 
        
        :: The 'in' core in the Hoon standard library contains the various functions for operating on sets.
        

        :: As with lists and trees, there are two categories of sets: null ~, and non-null. Hoon implements sets using trees for the underlying noun.


        :: Two common methods for populating a set include 
        
        :: (1) creating it from a list of values using the 'sy' function, and 
        
        :: (2) inserting items into a set using the 'put' arm of the in core.


        :: Using 'sy':

            =c (sy ~[11 22 33 44 55])

            c
            :: [n=11 l={} r={22 55 33 44}]

            `(set @)`c
            :: {11 22 55 33 44}

            =c `(set @)`c



            :: (!) Note that the dojo does not necessarily print elements of a set in the same order they were given. (!) 
            
            :: Mathematically speaking, sets are not ordered, so this is alright. There is no difference between two sets with the same elements written in a different order. 
            
            :: Try forming c with a different ordering and check this.


        :: And we can add an item to the set using 'put' of 'in':

            (~(put in c) 77)
            :: [n=11 l={} r={22 77 55 33 44}]

            `(set @)`(~(put in c) 77)
            :: {11 22 77 55 33 44}


        :: You can remove items using 'del' of 'in':

            (~(del in c) 55)
            :: [n=11 l={} r={22 33 44}]

            `(set @)`(~(del in c) 55)
            :: {11 22 33 44}


        :: Check whether an item is in the set using 'has' of 'in':

            (~(has in c) 33)
            :: %.y

            (~(has in c) 100)
            :: %.n


        :: You can apply a gate to each item of a set using 'run' of 'in' and produce a new set from the products:

            c
            :: {11 22 55 33 44}

            (~(run in c) |=(a=@ +(a)))
            :: {56 45 23 12 34}


        :: You can also apply a gate to all items of the set and return an accumulated value using 'rep' of 'in':

            c
            :: {11 22 55 33 44}

            (~(rep in c) add)
            :: b=165



        :: The standard library also has the 'union' and 'intersection' functions for sets:

            c
            :: {11 22 55 33 44}

            =d `(set @)`(sy ~[33 44 55 66 77])

            d
            :: {66 77 55 33 44}

            (~(int in c) d)
            :: [n=33 l=[n=55 l={} r={}] r=[n=44 l={} r={}]]

            `(set @)`(~(int in c) d)
            :: {55 33 44}

            (~(uni in c) d)
            :: [n=11 l=[n=66 l={} r={}] r=[n=33 l={22 77 55} r={44}]]

            `(set @)`(~(uni in c) d)
            :: {66 11 22 77 55 33 44}



        :: It may be convenient to turn a set into a list for some operation and then operate on the list. You can convert a set to a list using 'tap' of 'in':

            c
            :: {11 22 33 44 55}

            ~(tap in c)
            :: ~[44 33 55 22 11]




        :: Cartesian Product

            :: Here's a program that takes two sets of atoms and returns the Cartesian product of those sets. 
            
            :: A Cartesian product of two sets a and b is a set of all the cells whose head is a member of a and whose tail is a member of b

                |=  [a=(set @) b=(set @)]
                =/  c=(list @)  ~(tap in a)
                =/  d=(list @)  ~(tap in b)
                =|  acc=(set [@ @])
                |-  ^-  (set [@ @])
                ?~  c  acc
                %=  $
                c  t.c
                acc  |-  ?~  d  acc
                    %=  $
                        d  t.d
                        acc  (~(put in acc) [i.c i.d])
                    ==
                ==


            :: Save this as cartesian.hoon in your urbit's pier and run in the dojo:

                =c `(set @)`(sy ~[1 2 3])

                c
                :: {1 2 3}

                =d `(set @)`(sy ~[4 5 6])

                > d
                :: {5 6 4}

                +cartesian [c d]
                :: {[2 6] [1 6] [3 6] [1 4] [1 5] [2 4] [3 5] [3 4] [2 5]}



    :: Maps



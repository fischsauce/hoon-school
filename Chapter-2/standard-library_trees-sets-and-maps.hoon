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



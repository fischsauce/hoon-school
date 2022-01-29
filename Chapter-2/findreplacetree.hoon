!:

:: Find and Replace

:: Here's a program that finds and replaces certain atoms in a (tree @).

    :: 'nedl' is the atom to be replaced, 'hay' is the tree, and 'new' is the new atom with which to replace 'nedl'

|=  [nedl=@ hay=(tree @) new=@]
^-  (tree @)
?~  hay  ~
:+  ?:  =(n.hay nedl)
    new
    n.hay
$(hay l.hay)
$(hay r.hay)

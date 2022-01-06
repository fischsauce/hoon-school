:: Other Runes

:: Here are a few more examples:


:: (pronounced "wut-col") is the simplest "wut" rune. It takes three children, also called subexpressions. 

?:

:: The first child is a boolean test, so it looks for a %.y or a %.n. 

:: The second child is a yes-branch, which is what we arrive at if the aforementioned boolean test evaluates to %.y. 

:: The third child is a no-branch, which we arrive at if the boolean test evaluates to %.n. 

:: These branches can contain any sort of Hoon expression, including further conditional expressions. Instead of the ?& expression in our %say generator above, we could have written:

:: ie

?:  ?&  (gte n 1)
        (lte n 100)
        =(0 (mod n 2))
    ==
    %.y
%.n

:: instead of:

:: ?&  (gte n 1)
::     (lte n 100)
::     =(0 (mod n 2))


::  ("wut-zap") is the logical "NOT" operator, which inverts the truth value of its single child. 

?!

:: Instead of:

(lte n 100) 

:: we could have written:
?! (gth n 100)



:: (wut-pam) takes three children. It branches on whether its first child is an atom:

?@ 



:: (wut-ket) takes three children. It branches on whether its first child is a cell:

?^ 


:: (wut-sig) takes three children. It branches on whether its first child is null:

?~ 


:: (wut-bar) takes an indefinite number of children. It's the logical "or" operator. It checks if at least one of its children is true:

?| 
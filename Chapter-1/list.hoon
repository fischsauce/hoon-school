::Outputs all natural numbers up until the user's initial input


:: |= creates a GATE, which takes an input, performs a computation, then outputs a result:
|=  end=@
:: end=@ is the first child of the initial RUNE. The end part is a name for the user's input. =@ restricts the input to type ATOM (a natural number).


:: The rest of the program contains the second CHILD:


:: =/ stores a value with a name and specifies its type. It takes 3 children:
=/  count=@  1
:: count=@ (1st child) stores 1 (2nd child) as 'count', and specifies that it has the @ type. count is keeping track of numbers to be included in the list.


:: |-  is a RUNE which functions as a restart point for recursion. It takes 1 child:
|-


:: ^- constrains output to a certain type. It takes 2 children
^-  (list @)
:: In this case, the specified type is (list @) - ie a list of ATOMS


:: ?: is a rune that evaluates wheteher its 1st child is TRUE or FALSE. If TRUE, the program branches to the 2nd child. If FALSE, it branches to the 3rd child. As such, it takes 3 children:
?:  =(end count)
:: =(end count) checkes if the user's input equals the 'count' value. If so, we end the program. 


::~ representes the NULL value. The program branches here if it finds that 'end' is equal to 'count'. Lists in Hoon always end with ~
  ~


:: :- is a RUNE which creates a CELL - an dorderd pair of values, eg [1 2]. It takes 2 children. In this case, it creates a cell out of whatever value is stored in 'count', and then the value of the next line.
:-  count

:: This code restarts the program at |- , except with the value stored in 'count' incremented by 1. ie "replace the value of count with count+1".
$(count (add 1 count))

:: Our program works by having each iteration of the list creating a cell. In each of these cells, the head -- the cell's first position -- is filled with the current-iteration value of count. The tail of the cell, its second position, is filled with the product of a new iteration of our code that starts at |-. This iteration will itself create another cell, the head of which will be filled by the incremented value of count, and the tail of which will start another iteration. This process continues until ?: branches to ~ (null). When that happens, the list is terminated and the program doesn't have anything else to do, so it ends. So, a built-out list of nested cells can be visualized like this:

::   [1 [2 [3 [4 ~]]]]
::
::          .
::         / \
::        1   .
::           / \
::          2   .
::             / \
::            3   .
::               / \
::              4   ~

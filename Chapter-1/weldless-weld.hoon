!:

:: Weld (concatenate) two lists without using the weld function.


:: Attempt 1 fails:
:: |=  input=[(list @) (list @)]
:: =|  output=(list @)
:: |-  ^-  (list @)
:: ?~  input  output
:: $(output [output i.input], input t.input)


:: Assign seperate variables (faces?) to each list input, instead of combining them:
|=  [a=(list @) b=(list @)]


:: OK:
|-  ^-  (list @)

:: ?~ (wut-sig) "branches on whether a wing of the subject is null" So; if 'input' is null, then print 'reversed'?
?~  a  b


:: produce a cell with the first value of a, then recursively replace a with it's tail
[i.a $(a t.a)]


:: WHERE DOES B COME IN???

:: Does ?~ iterate on both its children? ie iterate on a until it's null, then continue to b?



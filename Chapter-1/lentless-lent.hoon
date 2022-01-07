!:

:: Lentless Lent

:: write a gate that takes a list and returns the number of items in it.

|=  input=(list @)

=/  count=@u  0

|-
?~  input  count
$(count (add count 1), input t.input)

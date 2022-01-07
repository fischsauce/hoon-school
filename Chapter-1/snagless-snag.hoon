!:

:: Snagless Snag


:: write a gate that returns the nth item of a list.

::Fails:

    :: |=  [input=(list @) nth=@]
    :: /=  result=@  ~
    :: |-
    :: ?:  =(nth 0)
    ::     result
    :: $(nth (dec nth), result (result t.result))


:: OK:
|=  [input=(list @) nth=@]


:: "branches on whether a wing of the subject is null":
?~  input  !!

:: "branches to second child if the first case is False":
?:  =(0 nth)  i.input

:: OK:
$(nth (dec nth), input t.input)

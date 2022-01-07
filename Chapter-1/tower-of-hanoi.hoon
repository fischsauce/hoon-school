!:
:: Tower of Hanoi

:: Disks are stacked on a pole by decreasing order of size. Move all of the disks from one pole to another with a third pole as a spare, moving one disc at a time, without putting a larger disk on top of a smaller disk.



    :: The user should define the number of disks to start with:

|=  n=@ud

    :: Set up 3 poles. The value of each pole is a set which reprensents the maximum disk size which is stacked upon it:

:: =/  a=@ud  0
=/  b=@ud  0
=/  c=@ud  0


    :: Using the generator from Lesson 1, we'll build a list onto pole a:

=/  a=@ud  0
|-
^-  (list @ud)
?:  =(n a)
    ~

    :: Nesting this doesn't work - why?
    :: |-
    :: ^-  (list @ud)
    :: ?:  =(a 1)
    ::     ~
    :: :-  a
    :: $(a (dec a 1))

:-  a
$(a (add a 1))


::     :: Starting from 1 (the disk on top) the number of each disk also represents its diameter (size)

:: |-
:: ^-  (list @u)
::     :: If pole C reaches the largest disk number, we are done:

:: ?:  =(b n)
::     'Finished'

:: :-  b
:: $(b (add b 1))

::     :: ...else we should begin the recursive opertaion to move the disks:


:: $(n (dec n), t (mul t n))

:: $(b )





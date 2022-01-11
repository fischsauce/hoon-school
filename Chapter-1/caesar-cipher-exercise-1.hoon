!:


:: Take the example generator and modify it to add a second layer of shifts.

    :: First, we'll add a third argument for the second shift:

:: |=  [msg=tape steps=@ud]
|=  [msg=tape steps=@ud steps2=@ud]


    :: =< is the rune that evaluates its first child expression with respect to its second child expression as the subject. 

    ::  Can we just add another =< to get nest a second iteration? No.
=<


=.  msg  (cass msg)


:: :-  (shift msg steps)
:: (unshift msg steps)


    :: Can we change the :- to a 4-tuple variety and repeat the shift/unshift methods? Yes!

:^  (shift msg steps)
(unshift msg steps)
(shift msg steps2)
(unshift msg steps2)

|%
++  alpha  "abcdefghijklmnopqrstuvwxyz"
++  shift
  |=  [message=tape shift-steps=@ud]
  ^-  tape
  (operate message (encoder shift-steps))
++  unshift
  |=  [message=tape shift-steps=@ud]
  ^-  tape
  (operate message (decoder shift-steps))
++  encoder
  |=  [steps=@ud]
  ^-  (map @t @t)
  =/  value-tape=tape  (rotation alpha steps)
  (space-adder alpha value-tape)
++  decoder
  |=  [steps=@ud]
  ^-  (map @t @t)
  =/  value-tape=tape  (rotation alpha steps)
  (space-adder value-tape alpha)
++  operate
  |=  [message=tape shift-map=(map @t @t)]
  ^-  tape
  %+  turn  message
  |=  a=@t
  (~(got by shift-map) a)
++  space-adder
  |=  [key-position=tape value-result=tape]
  ^-  (map @t @t)
  (~(put by (map-maker key-position value-result)) ' ' ' ')
++  map-maker
  |=  [key-position=tape value-result=tape]
  ^-  (map @t @t)
  =|  chart=(map @t @t)
  ?.  =((lent key-position) (lent value-result))
  ~|  %uneven-lengths  !!
  |-
  ?:  |(?=(~ key-position) ?=(~ value-result))
  chart
  $(chart (~(put by chart) i.key-position i.value-result), key-position t.key-position, value-result t.value-result)
++  rotation
  |=  [my-alphabet=tape my-steps=@ud]
  =/  length=@ud  (lent my-alphabet)
  =+  (trim (mod my-steps length) my-alphabet)
  (weld q p)
--
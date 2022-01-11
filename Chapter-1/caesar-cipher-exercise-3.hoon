!:

:: Build a gate that can take a Caesar shifted tape and produce all possible unshifted tapes.



:: Instead of taking in a tape and @ud, we'll just accept a tape:

|=  [msg=tape]
:: |=  [msg=tape steps=@ud]

=<
=.  msg  (cass msg)
:: :-  (shift msg)

=/  count=@ud  27

|-
:: :-

?:  =(count 0)  ~

:: :-  (shift msg count)  (dec count)

:: :-  (shift msg count)  (dec count)

:: $((shift msg count), count (dec count))


$(count (dec count))

:: ?:  =(n 0)  
:: $(m (dec m), n 1)

:: $(msg (shift msg), count (dec count))
:: (msg $(shift msg), count $(dec count))


:: $(m (dec m), n $(n (dec n)))



:: |=  [msg=tape steps=@ud]
:: =<
:: =.  msg  (cass msg)
:: :-  (shift msg steps)
:: (unshift msg steps)







:: $  (shift msg)
:: (shift msg)




:: remove unshift for now:

:: (unshift msg steps)

|%

++  alpha  "abcdefghijklmnopqrstuvwxyz"


:: We want shift

++  shift
  |=  [message=tape count=@ud]
  :: =/  count2=@ud  5
  ^-  tape
::   ?:  =(count 0)
    :: ~
  
  (operate message (encoder count))

::   (count (dec count))


::   We don't really need unshift for this exercise:

:: ++  unshift
::   |=  [message=tape shift-steps=@ud]
::   ^-  tape
::   (operate message (decoder shift-steps))


++  encoder
  |=  [steps=@ud]
  ^-  (map @t @t)
  =/  value-tape=tape  (rotation alpha steps)
  (space-adder alpha value-tape)


::   ...or the decoder:

:: ++  decoder
::   |=  [steps=@ud]
::   ^-  (map @t @t)
::   =/  value-tape=tape  (rotation alpha steps)
::   (space-adder value-tape alpha)


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
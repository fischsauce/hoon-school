!:

:: Extend the example generator to allow for use of characters other than a-z. Make it shift the new characters independently of the alpha characters, such that punctuation is only encoded as other punctuation marks.


    :: Add another argument for the shift value of the new characters:
|=  [msg=tape steps-alpha=@ud steps-punc=@ud steps-num=@ud]
=<
=.  msg  (cass msg)

    :: Add those extra vars as children to be evaluated within shift/unshift:
:-  (shift msg steps-alpha steps-punc steps-num)
(unshift msg steps-alpha steps-punc steps-num)

|%
++  alpha  "abcdefghijklmnopqrstuvwxyz"


    :: We'll add a new arm, called 'punc' - which will contain our list of allowed punctuation and special characters:
++  punc  ",.-:;'?()!$&%"
    :: NB: Unsure how to do escape chars in hoon, so we'll leave out the " symbol.


    :: Let's add another arm, just for numbers:
++  numbers  "0123456789"


++  shift
  |=  [message=tape shift-steps-alpha=@ud shift-steps-punc=@ud shift-steps-num=@ud]
  ^-  tape

    :: Pass the additional @ud for punctuation & number-shift steps to the operate arm:
  (operate message (encoder shift-steps-alpha shift-steps-punc shift-steps-num))

++  unshift
  |=  [message=tape shift-steps-alpha=@ud shift-steps-punc=@ud shift-steps-num=@ud]
  ^-  tape

  :: Pass the additional @ud for punctuation & number-shift steps to the operate arm:
  (operate message (decoder shift-steps-alpha shift-steps-punc shift-steps-num))



++  encoder
  |=  [steps-alpha=@ud steps-punc=@ud steps-num=@ud]
  ^-  (map @t @t)

  :: The new value-tape will be the weld-ed combination of each seperate rotation method on each of alpha/punc/numbers:
  =/  value-tape=tape  (weld (weld (rotation alpha steps-alpha) (rotation punc steps-punc)) (rotation numbers steps-num))

  :: We also want to weld the original lists and pass them to the space-adder: 
  (space-adder (weld (weld alpha punc) numbers) value-tape)
  

++  decoder
  |=  [steps-alpha=@ud steps-punc=@ud steps-num=@ud]
  ^-  (map @t @t)

  :: The new value-tape will be the weld-ed combination of each seperate rotation method on each of alpha/punc/numbers:
  =/  key-tape=tape  (weld (weld (rotation alpha steps-alpha) (rotation punc steps-punc)) (rotation numbers steps-num))

  :: We also want to weld the original lists and pass them to the space-adder: 
  (space-adder key-tape (weld (weld alpha punc) numbers))


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


++  punc-adder
  |=  [key-position=tape value-result=tape]
  ^-  (map @t @t)
  (~(put by (map-maker key-position value-result)) '!' '@')


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


    :: Duplicate the rotation arm? We needn't do that, since it should be compatible with our new 'punc' tape.

++  rotation
  |=  [my-alphabet=tape my-steps=@ud]
  =/  length=@ud  (lent my-alphabet)
  =+  (trim (mod my-steps length) my-alphabet)
  (weld q p)
--


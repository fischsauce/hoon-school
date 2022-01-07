!:

:: Flop a list without using flop:

|=  input=(list @)

:: This doesn't work:
:: =/  reversed=(list @)  [~]

:: Why =| (tis-bar) here? "combines default type value with the subject"
=|  reversed=(list @)


:: |- (bar-hep) "produces a trap (a core with one arm) and evaluates it" -- ^- (ket-hep) "typecasts by explicit type label"
|-  ^-  (list @)


:: wut-sig "branches on whether a wing of the subject is null" So; if 'input' is null, then print 'reversed'?
?~  input  reversed


:: Take the empty list 'reversed' and replace it with the first value (i.) of 'input', then itself, then replace l with its last (t.) values
$(reversed [i.input reversed], input t.input)


:: eg reversed = [1 ~] , input = [2 3 4 5] then:
:: [2] + [1 ~], [3 4 5] 
:: [3] + [2 1 ~], [4 5], etc.




:: =>(s=`(list @)`l ?~(s ~ i.s))

:: (flop s)

:: |-
:: :: ?:  =(l (flop l))
:: ::     l
:: ?:  =(r (flop l))
::     r

:: =/  o=@  (l=`(list @)`l ?~(l ~ t.l))

:: $(r (add t.l), l (dec t.l))
:: $(l (dec t.l))


:: =>(l=`(list @)`l ?~(l ~ t.l))

:: =/  t=@ud  1
:: |-
:: ?:  =(n 1)
::     t
:: $(n (dec n), t (mul t n))

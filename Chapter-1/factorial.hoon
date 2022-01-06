:: Factorial In Hoon

:: |=  n=@ud
:: ?:  =(n 1)
::   1
:: (mul n $(n (dec n)))

:: Our gate takes one sample (argument) n that must nest inside @ud, the unsigned-integer type:

|=  n=@ud


:: Next we check to see if n is 1. If so, the result is just 1, since 1 * 1 = 1.

?:  =(n 1)
  1


:: If, however, n is not 1, then we branch to the final line of the code where the recursion logic lives. Here, we multiply n by the recursion of n minus 1:

(mul n $(n (dec n)))

:: $ (!) INITIATES RECURSION (!): it calls the gate that we're already in, but replaces its sample.

:: Gates will continue to call new, further-decremented gates until n is 1, and that 1 will be the final number to be multiplied by.


:: The pseudo-Hoon below illustrates what happens when we use it to find the factorial of 5:

:: (factorial 5)
:: (mul 5 (factorial 4))
:: (mul 5 (mul 4 (factorial 3)))
:: (mul 5 (mul 4 (mul 3 (factorial 2))))
:: (mul 5 (mul 4 (mul 3 (mul 2 (factorial 1)))))
:: (mul 5 (mul 4 (mul 3 (mul 2 1))))
:: (mul 5 (mul 4 (mul 3 2)))
:: (mul 5 (mul 4 6))
:: (mul 5 24)
:: 120
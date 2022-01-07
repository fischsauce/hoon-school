!:
:: Fibonacci generator

:: 0 1 1 2 3 5 8 13 ...


    :: We'll start by taking an input, 'count' as the nth Fibonacci to stop at

|=  count=@u


    :: Then we want to assign a new variable to maintain the current (nth) Fibonacci...

=/  fibonacci=@u  0


    :: Along with a placeholder for the previous fibonacci (we assign it a value of 1 to create the intiala pair):

=/  previous=@u  1
|-


    :: If the input is 0, we should terminate immediatly:

:: ?:  =(count 0)
::     'Please enter a value GTE 1'
       
       :: This seems to mess with the output of 'fibonacci' in the next wut-col, **WHY?**


    :: If the count == 1, then we should end the program and display the result (the nth Fibonacci)

?:  =(count 1)
    fibonacci


    :: ...else we continue, Decrement the count, add the previous two Fibonaccis, then reassign the n-1th Fibonacci to the current. Using mul 1 here since I haven't worked out how to reassign directly whilst inside a gate...

$(count (dec count), fibonacci (add fibonacci previous), previous (mul fibonacci 1))

:: !:

:: Conditionals

:: We will write a generator that takes an integer and checks if it is an even number between 1 and 100.

:: :-  %say
:: |=  [* [n=@ud ~] ~]
:: :-  %noun
:: ^-  ?
:: ?&  (gte n 1)
::     (lte n 100)
::     =(0 (mod n 2))
:: ==


:: On the very first line, with :- %say we are beginning to create a generator of the %say variety. The result of a %say generator is a cell with a head of %say and tail that is a gate, itself producing a cask, a pair of a mark and some data.

:-  %say



:: The gate's first argument is a cell provided by Dojo that contains some system information we're not going to use, so we use * to indicate "any noun". The next cell is our arguments provided to the generator upon invocation at the Dojo. Here we only want one @ud (unsigned decimal) with the face n.

|=  [* [n=@ud ~] ~]



:: The third line of the %say "boilerplate" produces a cask with the head of %noun. We could use any mark here, but %noun is the most generic type, able to fit any data.

:-  %noun



:: This line casts the output as a flag, which is a type whose values are %.y and %.n representing "yes" and "no". These behave as boolean values (true or false).

^-  ?



:: ?& (pronounced "wut-pam") takes in a list of Hoon expressions, terminated by ==, that evaluate to a flag and returns the logical "AND" of these flags. If the product of each of the children of ?& is %.y, then the product of the entire ?& expression is %.y as well. Otherwise, the product of the conditional ?& is %.n.

?&  (gte n 1)

:: The first child of ?& is (gte n 1). It is good practice to put the first boolean test of a conditional on the same line as the conditional, as we have done here. This utilizes the standard library function gte which stands for "greater than or equal to". (gte a b) returns %.y if a is greater than or equal to b, and %.n otherwise.



:: lte is the standard library function for "less than or equal to". (lte a b) returns %.y if a is less than or equal to b, and %.n otherwise.

(lte n 100)



:: This checks to see if 0 is equal to (mod n 2) -- in other words, checking if n is even. It produces %.y if n is even and %.n if n is odd.

=(0 (mod n 2))

:: It is good practice in Hoon to put "lighter" lines at the top and "heavier" lines at the bottom, which is why we have put =(0 (mod n 2)) last in the list of conditionals.



:: Finally we have a terminator. This marks the end of the list of children of ?&

==



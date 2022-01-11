!:

:: Bank Account

    :: we will write a door that can act as a bank account with the ability to withdraw, deposit, and check the account's balance.

:-  %say
|=  *
:-  %noun
=<  =~  new-account
    (deposit 100)
    (deposit 100)
    (withdraw 50)
    balance
    ==
|%
++  new-account
    |_  balance=@ud
    ++  deposit
        |=  amount=@ud
        +>.$(balance (add balance amount))
    ++  withdraw
        |=  amount=@ud
        +>.$(balance (sub balance amount))
    --
--



:: We start with the three lines we have in every %say generator:

:: We're creating a cell. 

:: The head of this cell is %say. 

:: The tail is a gate (|=  *) that produces another cell (:-  %noun) with a head of the mark of a the kind of data we are going to produce, a noun; the tail of the second cell is the rest of the program.

    :: :-  %say
    :: |=  *
    :: :-  %noun




:: In this code, we're going to compose two runes using =<, which has inverted arguments. We use this rune to keep the heaviest twig to the bottom of the code.

:: =~ is a rune that composes multiple expressions. 

:: We take new-account and use that as the subject for the call to deposit. 

:: deposit and withdraw both produce a new version of the door that's used in subsequent calls, which is why we are able to chain them in this fashion. 

:: The final reference is to balance, which is the account balance contained in the core that we examine below.

    :: =<  =~  new-account
    ::     (deposit 100)
    ::     (deposit 100)
    ::     (withdraw 50)
    ::     balance
    ::     ==




:: We've chosen here to wrap our door in its own core to emulate the style of programming that is used when creating libraries. 

:: new-account is the name of our door. Recall that a door is a core with one or more arms that has a sample. 

:: Here, our door has a sample of one @ud with the face balance and two arms deposit and withdraw.

:: Each of these arms produces a gate which takes an @ud argument. Each of these gates has a similar bit of code inside:

    :: +>.$(balance (add balance amount))

    :: +> is wing syntax. This particular wing construction looks for the tail of the tail (the third element) in $, the subject of the gate we are in. 
    
:: The withdraw and deposit arms create gates with the entire new-account door as the context in their cores' [battery sample context], in the "tail of the tail" slot. 

:: We change balance to be the result of adding balance and amount and produce the door as the result. withdraw functions the same way only doing subtraction instead of addition.


    :: |%
    :: ++  new-account
    ::   |_  balance=@ud
    ::   ++  deposit
    ::     |=  amount=@ud
    ::     +>.$(balance (add balance amount))
    ::   ++  withdraw
    ::     |=  amount=@ud
    ::     +>.$(balance (sub balance amount))
    ::   --
    :: --


:: It's important to notice that the sample, balance, is stored as part of the door rather than existing outside of it.

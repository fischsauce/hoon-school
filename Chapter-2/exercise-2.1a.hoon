:!

:: Exercise 2.1a

    :: Does Hoon's @s aura make a distinction between positive and negative zero, e.g., -0 and --0? 
    
    :: Use what you've learned in this lesson so far to come up with a principled answer.


    :: The (inferred) type given in dojo:?>

        ? -0
        :: @sd
        :: --0


        ? --0
        :: @sd
        :: --0


        :: There doesn't appear to be a distinction in dojo output. Can we test to make sure?

            ? (sum:si --0 --0)
            :: @s
            :: --0

            ? (sum:si -0 -0)
            :: @s
            :: --0

            ? (sum:si -0 -0)
            :: @s
            :: --0


        :: What is the underlying @ud for --0 and -0?

            `@ud`--0
            :: 0

            `@ud`-0
            :: 0

            `@ud`0
            :: 0


        :: ... and the equivalent @sd?

            ?`@sd`--0
            :: --0

            `@sd`-0
            :: --0

            `@sd`0
            :: --0


    :: So I think we can say that because both --0 and -0 resolve to the same signed or unsigned aura, there is no distinction.




        

    


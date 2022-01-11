!:

:: Generators

    :: Generators are the most straightforward way to write programs for Urbit. 
    
    :: They are used for doing computations that do not require persistence: they take an input and produce an output, then disappear. 
    
    :: Generators might make sense for listing directory contents, or running unit tests, or fetching the contents of a URL.



    :: There are three kinds of generators: naked, %say, and %ask. There also used to be a fourth type of generator, %get, but this kind is no longer in use.




    :: Naked Generators
        
        :: A naked generator is simply a gate; that is, it is an anonymous function that takes a sample (argument) and produces a noun. 
        
        :: All you need to do is write a gate and put it into a file in the /gen directory of a desk on your ship. Let's take a look at a very simple one:

            |=  a=*
            :: a

        :: This generator takes one argument of any noun and produces it without any changes. 
        
        :: Put this into a file named echo.hoon in the /gen directory of your %base desk. You must make your ship recognize the change by inputting |commit %base in the dojo. You can then run it from the dojo:

            +echo 42
            :: 42




        :: This command just passes in 42 and gets 42 back. But what about when we pass in "asdf"?

            +echo "asdf"
            :: [97 115 100 102 0]

        
        :: We just get a pile of numbers back in the form of a raw noun. 
        
        :: The numbers that compose that noun are called atoms, and how they are interpreted is a matter of what aura is being applied to them. 
        
        :: For the purposes of this lesson, an aura tells the pretty-printer how to display an atom, but keep in mind that an aura is type metadata and does other things, too.




        :: In the example above, we didn't specify an aura, leaving the printer to fend for itself. "asdf" is a tape, a type that is simply a list of cords.
        
        ::  A cord is itself an atom represented as a string of UTF-8 characters. When used as part of a tape, the cord is only a single character. So each atom in the [97 115 100 102 0] output corresponds to a component of the tape: 97 is a, 115 is s, 100 is d, 102 is f, and 0 is the "null" that every list is terminated with.




        :: We can tell the Dojo to cast -- apply a specific type to -- the output of our generator to see something more familiar:

            :: _tape +echo "asdf"
            "asdf"




        :: Now let's create a generator with two arguments instead of one. Save the code below as add.hoon in the /gen directory of your %base desk.

            |=  [a=@ud b=@ud]
            (add a b)
            
            :: Now, run the generator:

            +add [3 4]
            :: 7


        :: You may notice our generator takes a cell containing two @ud. 
        
        :: (!) This is actually one of the limitations of naked generators. We can only pass one argument. (!)
        
        :: We can get around this, of course, by passing a cell, but it's less than ideal. 
        
        :: (!) Also, a naked generator cannot be called without an argument. This brings us to %say generators (!)





    :: %say Generators

        :: We use %say generators when we want to provide something else in Arvo, the Urbit operating system, with metadata about the generator's output. 
        
        :: This is useful when a generator is needed to pipe data to another program, a frequent occurrence.



        :: To that end, %say generators use 'marks' to make it clear, to other Arvo computations, exactly what kind of data their output is. 
        
        :: (!) A mark is akin to a MIME type on the Arvo level (!) 
        
        :: A mark describes the data in some way, indicating that it's an %atom, or that it's a standard such as %json, or even that it's an application-specific data structure like %talk-command. 
        
        :: Marks are not specific to %say generators; whenever data moves between programs in Arvo, that data is marked.




        :: So, more formally, a %say generator is a cell. 
        
        :: The head of that cell is the %say tag, and the tail is a gate that produces a cask -- a pair of the output data and the mark describing that data.




        :: Below is an example of a %say generator. Save it to add.hoon in the /gen directory of your %base desk.

            :-  %say
            |=  *
            :-  %noun
            (add 40 2)

        :: Now run the generator as below:

            > +add
            :: 42
            
        :: Notice that we used no argument, something that is possible with %say generators but impossible with naked generators. 



        :: Recall that the rune :- produces a cell, with the first following expression as its head and the second following expression as its tail.

        :: The expression above creates a cell with %say as the head:

            :-  %say

        :: The tail is the |= * expression on the line that follows:

        :: |= * constructs a gate that takes a noun. This gate will itself produce a cask, which is cell formed by the prepending :-. 
        
        :: The head of that cask is %noun and the tail is the rest of the program, (add 40 2). The tail of the cask will be our actual data produced by the body of the program: in this case, just adding 40 and 2 together.

            |=  *
            :-  %noun
            (add 40 2)


        


        :: %say generators with arguments

            :: We can modify the boilerplate code to allow arguments to be passed into a %say generator, but in a way that gives us more power than we would have if we just used a naked generator.


            :: Naked generators are limited because they have no way of accessing data that exists in Arvo, such as the date and time or pieces of fresh entropy.


            :: In %say generators, however, we can access that kind of subject by identifying them in the gate's sample, which we only specified as * in the previous few examples. 
            
            :: But we can do more with %say generators if we do more with that sample. 

            :: (!) Any valid sample will follow this 3-tuple scheme (!)

                [[now, eny, beak] [list of unnamed arguments] [list of named arguments]]

                [
                    [now, eny, beak] 
                    [list of unnamed arguments] 
                    [list of named arguments]
                ]

                :: This entire structure is a noun, which is why * is a valid sample if we wish to not use any of the information here in a generator. 



                :: The first part of the above 3-tuple is a noun that is composed of three atoms:


                    :: now is the current time. 
                    
                    :: eny is 512 bits of entropy for seeding random number generators. 
                    
                    :: beak contains the current ship, desk, and case.


                    :: You can access each of those pieces of data by typing their names into the Dojo. 
                    
                    :: But in a generator, we need to put faces (variable names) onto that data so we can easily use it in the program. We can do so like this:

                        |=  [[now=@da eny=@uvJ bec=beak] ~ ~]



                    :: Any of those pieces of data could be omitted by replacing part of the noun with * rather than giving them faces. 
                    
                    :: For example:
                    
                         [now=@da * bec=beak] ::if we didn't want eny, or 
                         
                         [* * bec=beak] :: if we only wanted beak.




                :: The second part of the sample is a list of arguments that must be passed to the generator as it is run. 
                
                    :: Because it's a list, this element needs to be terminated with a ~. 
                    
                    :: In the example above, we used ~, the empty list, to represent this second part. 
                    
                    :: But that would mean we don't want to use any new faces for our generator. 
                    
                    :: So a sample where we want to declare a single required argument would look like this:

                        |=  [* [n=@ud ~] ~]


                    :: In the above code, we use a * to ignore any of the information that would go in the first part of the sample, somewhat similar to how we use a ~ to say "nothing here" for the second or third parts of the sample.


                    :: But to use both parts together, our gate and sample would look like this:

                        |=  [[now=@da eny=@uvJ bec=beak] [n=@ud ~] ~]


                


                :: The third part of the sample is a list of optional arguments. 
                
                    :: These arguments may be passed to the program as it's being run, but the program doesn't require them. 
                    
                    :: The syntax for the third part is just like the syntax for the second part, besides its position:

                        |=  [* ~ [bet=@ud ~]]





            :: Let's look at an example that uses all three parts. Save the code below in a file called dice.hoon in the /gen directory of your %base desk.

                :-  %say
                |=  [[now=@da eny=@uvJ bec=beak] [n=@ud ~] [bet=@ud ~]]
                :-  %noun
                [(~(rad og eny) n) bet]


            :: This is a very simple dice program with an optional betting functionality. 
            
            :: In the code, our sample specifies faces on all of the Arvo data, meaning that we can easily access them. 
            
            :: We also require the argument [n=@ud ~], and allow the optional argument [bet=@ud ~].


            :: But there's something new: 
                
                (~(rad og eny) n). 
                
            :: This code pulls the rad arm out of the og core with the subject of eny. Recall that eny is our entropy value, so this is used to seed the generator. The rad arm will give us a pseudorandom number between 0 and n.
            
            ::  Then we form a cell with the result and bet, the optional named argument specified previously.

            :: We can run this generator like so:

                +dice 6, =bet 2
                :: [4 2]

            :: We get a different value from the same generator between runs, something that isn't possible with a naked generator. 
            
            :: Another novelty is the ability to choose to not use the second argument.





        :: Arguments without a cell

            :: Also unlike a naked generator, we don't need to put our arguments together into a cell. 
            
            :: Swap the code below into your add.hoon file:

                :-  %say
                |=  [* [a=@ud b=@ud ~] ~]
                :-  %noun
                (add a b)

            
            :: In the above code we're again creating a %say generator, but the sample of our gate is a little different than before. 
            
            :: We are using * for the first part of the sample, because we don't use any Arvo data in this program. We are using a ~ for the third part, because we aren't allowing optional arguments -- the list of optional arguments is empty.

            :: Run a command like the one below in the Dojo. Notice that you can use two arguments that aren't in the cells.

                +add 40 2
                :: 42



            

    :: %ask generators

        :: The code below is an %ask generator that checks if the user inputs "blue" when prompted. Save it as axe.hoon in the /gen directory of your %base desk.

            /-  sole
            /+  generators
            =,  [sole generators]
            :-  %ask
            |=  *
            ^-  (sole-result (cask tang))
            %+  print    leaf+"What is your favorite color?"
            %+  prompt   [%& %prompt "color: "]
            |=  t=tape
            %+  produce  %tang
            ?:  =(t "blue")
            :~  leaf+"Oh. Thank you very much."
                leaf+"Right. Off you go then."
            ==
            :~  leaf+"Aaaaagh!"
                leaf+"Into the Gorge of Eternal Peril with you!"
            ==

        
        :: Run the generator from the Dojo:

            +axe
            :: What is your favorite color?
            :: : color:

        :: Something new happened. Instead of simply returning something, your Dojo's prompt changed from ~your-urbit:dojo> to ~your-urbit:dojo: color:, and now expects additional input. Let's give it an input:

            ::  color: red
            :: Into the Gorge of Eternal Peril with you!
            :: Aaaaagh!
        
        
        
        :: Let's go over what exactly is happening in this code.


            :: Here we bring in some of the types we are going to need from /sur/sole and gates we will use from /lib/generators. We use some special runes for this.

                :: /- is a Ford rune used to import types from sur.
                /-  sole


                :: /+ is a Ford rune used to import libraries from lib:
                /+  generators


                :: =, is a rune that allows us to expose a namespace. We do this to avoid having to write sole-result:sole instead of sole-result or print:generators instead of print.
                =,  [sole generators]



            :: This code might be familiar. Just as with their %say cousins, %ask generators need to produce a cell, the head of which specifies what kind of generator we are running.


                :-  %ask

                :: With |= *, we create a gate and ignore the standard arguments we are given, because we're not using them.
                |=  *



            :: %ask generators need to have the second half of the cell be a gate that produces a sole-result, one that in this case contains a cask of tang. 
            
                :: We use the ^- rune to constrain the generator's output to such a sole-result.

                ^-  (sole-result (cask tang))




            :: (!) A cask is a pair of a mark name and a noun (!)



            :: Recall that a mark can be thought of as an Arvo-level MIME type for data.

            :: A 'tang' is a 'list' of 'tank'
            
            :: A tank is a structure for printing data. 
            
            :: There are three types of tank: leaf, palm, and rose. 
            
                :: A 'leaf' is for printing a single noun, 
                :: a 'rose' is for printing rows of data, and 
                :: a 'palm' is for printing backstep-indented lists.




            :: Because we imported generators, we can access its contained gates, three of which we use in axe.hoon: print, prompt, and produce.

                :: print is used for printing a tank to the console.

                :: In our example, %+ is the rune to call a gate, and our gate print takes one argument which is a tank to print. 
                
                :: The + here is syntactic sugar for [%leaf "What is your favorite color?"] that just makes it easier to write.

                %+  print    leaf+"What is your favorite color?"
            


                :: prompt is used to construct a prompt for the user to provide input. It takes a single argument that is a tuple. Most %ask generators will want to use the prompt gate.

                :: The first element of the prompt sample is a flag that indicates whether what the user typed should be echoed out to them or hidden. 
                
                    :: (!) %& will produce echoed output and %| will hide the output (for use in passwords or other secret text) (!)


                :: The second element of the prompt sample is intended to be information for use in creating autocomplete options for the prompt. This functionality is not yet implemented.

                :: The third element of the prompt sample is the tape that we would like to use to prompt the user. In the case of our example, we use "color: ".
            
            
                %+  prompt   [%& %prompt "color: "]




                :: produce is used to construct the output of the generator. In our example, we produce a tang

                :: Our gate here takes a tape that was produced by prompt. If we needed another type of data we could use parse to obtain it.

                |=  t=tape

                %+  produce  %tang



        :: One quirk that you should be aware of, though, is that tang prints in reverse order from how it is created. 
        
        :: The reason for this is that tang was originally created to display stack trace information, which should be produced in reverse order. 
        
        :: This leads to an annoyance: we either have to specify our messages backwards or construct them in the order we want and then flop the list. 
        
        :: This is a known issue to be resolved.




    :: %get generators

        :: %get generators no longer exist. They were once used for making HTTP requests through eyre. Such functionality is no longer supported with generators.

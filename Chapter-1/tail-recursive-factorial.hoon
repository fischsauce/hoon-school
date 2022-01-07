:: Tail-Call Optimization

    :: |=  n=@ud
    :: ?:  =(n 1)
    ::   1
    :: (mul n $(n (dec n)))

    :: Every time a parent gate calls another gate, the gate being called is "pushed" to the top of the stack in the form of a frame. This process continues until a value is produced instead of a function, completing the stack.

    ::                   Push order      Pop order
    :: (fifth frame)         ^               |
    :: (fourth frame)        |               |
    :: (third frame)         |               |
    :: (second frame)        |               |
    :: (first frame)         |               V

    :: When a frame is popped, it executes the contained gate and passes produced data to the frame below it. This process continues until the stack is empty, giving us the gate's output.


    :: When a program's final expression uses the stack in this way, it's considered to be NOT TAIL-RECURSIVE. That's because such an expression needs to hold each iteration of $(n (dec n) in memory so that it can know what to run against the mul function every time.


    :: if you have to manipulate the result of a recursion as the last expression of your gate, as we did in our example, the function is not tail-recursive, and therefore not very efficient with memory.


    :: the Hoon compiler, like most compilers, is smart enough to notice when the last statement of a parent can reuse the same frame instead of needing to add new ones onto the stack. If we write our code properly, we can use a single frame that simply has its values replaced with each recursion.




:: A Tail-Recursive Gate

    :: we can write a version of our factorial gate that is tail-recursive and can take advantage of this feature:

    :: |=  n=@ud
    :: ?:  =(n 1)
    ::   1
    :: (mul n $(n (dec n)))

|=  n=@ud
=/  t=@ud  1
|-
?:  =(n 1)
    t
$(n (dec n), t (mul t n))


    :: We are still building a gate that takes one argument n. This time, however, we are also putting a face on a @ud and setting its initial value to 1. The |- here is used to create a new gate with one arm $ and immediately call it. Think of |- as the recursion point.

    :: We then evaluate n to see if it is 1. If it is, we return the value of t. In case that n is anything other than 1, we perform our recursion:

    :: $(n (dec n), t (mul t n))

    :: t is used as an accumulator variable that we use to keep a running total for the factorial computation.

    :: (factorial 5)
    :: (|- 5 1)
    :: (|- 4 5)
    :: (|- 3 20)
    :: (|- 2 60)
    :: (|- 1 120)
    :: 120

    :: Since this $ call is the final and solitary thing that is run in the default case and since we are doing all computation before the call, this version is properly tail-recursive.

    :: We don't need to do anything to the result of the recursion except recurse it again. That means that each iteration can be replaced instead of held in memory.



:: A Note on $

    :: $ (pronounced "buc") is, in its use with recursion, a reference to the gate that we are inside of. 

    :: That's because a gate is just a core with a single arm named $. The subject is searched depth-first, head before tail, with faces skipped, and stopping on the first result.

    :: In other words, THE FIRST MATCH FOUND IN THE HEAD WILL BE RETURNED.

    :: If you wished to refer to the outer $ in this context, the idiomatic way would be to use ^$. The ^ operator skips the first match of a name.

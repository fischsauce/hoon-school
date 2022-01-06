!: ::(for debugging)

:: Hoon does not accept any other characters in source files except for UTF-8 in quoted strings. 

"Some UTF-8: ἄλφα"


:: Expressions of Hoon

:: Noun Literals

:: A NOUN is either an ATOM or a CELL.

:: There are LITERAL expressions for each kind of noun. A noun literal is just a notation for representing a fixed noun value. A BASIC EXPRESSION OF HOON THAT EVALUATES TO ITSELF.


:: ATOM LITERALS:
1
:: 1

123
:: 123


:: CELL LITERALS:

[6 7]
:: [6 7]

[[12 14] [654 123.456 980]]
:: [[12 14] 654 123.456 980]


:: These are valid expressions but they aren’t cell literals:

[(add 22 33) (mul 22 33)]
:: [55 726]


:: WINGS

:: A WING expression is a series of limb expressions separated by . (dot)

:: A LIMB expression is a trivial wing expression -- there is only one limb in the series. Some one-limb wings:

+2
-
+>
&4
a
b
add
mul


:: As a special limb we also have $ (buc). This is the name of the ARM in special one-armed cores called “gates”. 

:: Wing expressions with multiple limbs are complex expressions. Examples:

+2.+3.+4
-.+.+
resolution.path.into.subject



:: Type Expressions

:: Hoon’s type system uses special symbols to indicate certain fundamental types: 
~ (null) ::, 
* (noun) ::, 
@ (atom) ::, 
^ (cell) ::, and 
? (flag) ::. 

:: Each of these symbols can be used as a stand-alone expression of Hoon. In the case of @ there may be a series of letters following it, to indicate an atom aura; e.g., 
@s ::, 
@rs ::, 
@tas ::, and 
@tD 

:: They may also be put in brackets to indicate compound types, e.g., 
[@ ^] ::, 
[@ud @sb] ::, 
[[? *] ^]



:: Rune Expressions

:: A RUNE is just a pair of ASCII characters (a digraph).

:: Runes are classified by family. The first symbol indicates teh family. The runes of particular family usually have related meanings. Two simple examples: the runes in the | (bar) family are all used to create cores, and the runes in the : (col) family are all used to create cells.

:: Runes generally do not need to be closed. 

:: All runes take a fixed number of children.

:: Children can themselves be runes.



:: Tall and Wide Forms

:: There are two rune syntax forms: TALL and WIDE. Tall form is usually used for multi-line expressions, and wide form is used for one-line expressions.

:: Tall form expressions may contain wide form subexpressions, but wide form expressions may not contain tall form.

:: In tall form, each rune and subexpression must be separated from the others by a gap -- that is, by two or more spaces, or a line break.

:: In wide form the rune is immediately followed by parentheses ( ), and the various subexpressions inside the parentheses must be separated from the others by an ace -- that is, by a single space.


:: The :- rune is used to produce a cell. Accordingly, it is followed by two subexpressions: the first defines the head of the cell, and the second defines the tail. eg:

:: if you want to, you can write tall form code on a single line:
:-  11  22
:: [11 22]

:-  11
  22
:: [11 22]

:-
  11
  22
:: [11 22]

:: The same :- expression in wide form is:
:-(11 22)
:: [11 22]


:: |% and |_ expressions, for example, can only be written in tall form.



:: Nesting Runes

:- :- 2 3 4
:: [[2 3] 4]

:-  2  :-  3  4
:: [2 [3 4]]
:: [2 3 4]

:: Exercise 1.3a

:: Draw binary trees corresponding to the above figures. Determine a one-to-one correspondence between linearly ordered nested boxes (i.e. what is depicted in the above figures) and binary trees. You will need to make use of the convention [a [b c]] = [a b c].

:- :- 2 3 4 :: [[2 3] 4]

::            .
::           / \
::          .   4
::         / \
::        2   3



:-  2  :-  3  4:: [2 [3 4]]

::        .
::       / \
::      2   .
::         / \
::        3   4


:: Irregular Forms

:: Some runes are used so frequently that they have irregular counterparts that are easier to write and which mean precisely the same thing (syntactic Sugar). 

:: All irregular syntax is WIDE.

:: All regular syntax is TALL.


:: The .= rune takes two subexpressions, evaluates them, and tests the results for equality. If they’re equal it produces %.y for “yes”; otherwise %.n for “no”. 

:: In TALL form:

.=  22  11
:: %.n

.=  22
  (add 11 11)
:: %.y>


:: In wide form:

.=(22 11)
:: %.n

.=(22 (add 11 11))
:: %.y


:: The irregular form of the .= rune is just =( ):

=(22 11)
:: %.n

=(22 (add 11 11))
:: %.y


:: (add 11 11) is the irregular form of %+, which calls a GATE (i.e., a Hoon function) with two arguments for the sample:

%+  add  11  11
:: 22

%+(add 11 11)
:: 22


:: The ( ) gate-calling syntax can be used for gates with any number of arguments.




:: Expressions That Are Only Irregular

:: There are certain irregular expressions that aren’t syntactic sugar for regular form equivalents -- they’re solely irregular. There isn’t much in general that can be said about these because they’re all different

:: Below we use the ` (tic) symbol to create a cell whose head is null, ~ (sig):

`12
:: [~ 12]

`[[12 14] 16]
:: [~ [12 14] 16]


:: Putting ,. in front of a wing expression removes a face, if there is one:

-:[a=[12 14] b=[16 18]]
a=[12 14]

,.-:[a=[12 14] b=[16 18]]
[12 14]

,.-:[[12 14] b=[16 18]]
[12 14]

+:[a=[12 14] b=[16 18]]
b=[16 18]

,.+:[a=[12 14] b=[16 18]]
[16 18]


:: There are a couple useful runes associated with DEBUGGING:

!: :: (zapcol), if written at the top of a Hoon file, turns on a full debugging stack-trace. It’s good practice to use whenever you’re learning.


~& :: (sigpam) is used to print its argument every time that argument executes. So, if you wanted to see how many times your program executed foo, you would write foo bar. Then, when your program runs, it will print foo on a new line of output every time the program comes across it by recursion.



:: A noun is either an atom or a cell. An atom is a natural number ("unsigned integer" in computer lingo) of any size, including zero. A cell is an ordered pair of nouns, usually indicated with square brackets around the nouns in question; i.e., [a b], where a and b are nouns.

:: Here are some atoms:

:: 0
:: 87
:: 325
:: Here are some cells:

:: [12 13]
:: [12 [487 325]]
:: [[12 13] [87 65]]
:: [[83 [1 17]] [[23 [32 64]] 90]]
:: All of the above are nouns.


:: Nouns as Binary Trees
:: All non-leaf nodes are cells:

:: [12 [17 45]]
::     .
::    / \
::  12   .
::      / \
::    17   45


:: [[7 13] [87 65]]
::          .
::         / \
::   [7 13]   [87 65]
::     .         .
::    / \       / \
::   7   13   87   65

:: Atoms are unsigned integers.


:: Atom Auras

:: Let's look at some other atom literal syntaxes: unsigned binary, unsigned hexadecimal, signed decimal, signed binary, and signed hexadecimal.

`@`0b1001

`@`0b1001.1101

`@`0x9d

`@`0xdead.beef

`@`--9

`@`-79

`@`--0b1001

`@`-0x9d


:: Identities, Cords, and Terms


:: Urbit identities such as ~zod and ~sorreg-namtyv are also atoms, but of the aura @p:

`@`~sorreg-namtyv
:: 5.702.400

`@p`5.702.400
:: ~sorreg-namtyv


:: Hoon permits the use of atoms as strings. Strings that are encoded as atoms are called CORDS. 

:: Cords are of the aura @t. The literal syntax of a cord is text inside a pair of single-quotes, e.g., 'Hello world!'.

`@`'Howdy!'
:: 36.805.260.308.296


:: Hoon also has TERMS, of the aura @tas.

:: Terms are constant values that are used to tag data using the type system. These are strings preceded with a % and made up of lowercase letters, numbers, and hyphens, i.e., "kebab case". The first character after the % must be a letter. For example:

%this-is-kebab-case123
:: %this-is-kebab-case123

`@`%howdy
:: 521.376.591.720


:: List of Auras:


::   Aura       Meaning                        Example of Literal Syntax
::   --------------------------------------------------------------------
::   @d         date
::   @da        absolute date                  ~2018.5.14..22.31.46..1435
::   @dr        relative date (ie, timespan)   ~h5.m30.s12
::   @n         nil                            ~
::   @p         phonemic base (urbit name)     ~sorreg-namtyv
::   @r         IEEE floating-point
::   @rd        double precision  (64 bits)    .~6.02214085774e23
::   @rh        half precision (16 bits)       .~~3.14
::   @rq        quad precision (128 bits)      .~~~6.02214085774e23
::   @rs        single precision (32 bits)     .6.022141e23
::   @s         signed integer, sign bit low
::   @sb        signed binary                  --0b11.1000
::   @sd        signed decimal                 --1.000.056
::   @sv        signed base32                  -0v1df64.49beg
::   @sw        signed base64                  --0wbnC.8haTg
::   @sx        signed hexadecimal             -0x5f5.e138
::   @t         UTF-8 text (cord)              'howdy'
::   @ta        ASCII text (knot)              ~.howdy
::   @tas       ASCII text symbol (term)       %howdy
::   @u         unsigned integer
::   @ub        unsigned binary             0b11.1000
::   @ud        unsigned decimal            1.000.056
::   @uv        unsigned base32             0v1df64.49beg
::   @uw        unsigned base64             0wbnC.8haTg
::   @ux        unsigned hexadecimal        0x5f5.e138


:: Cells

:: The left of a cell is called the HEAD, and the right is called the TAIL. Cells are typically represented in Hoon with square brackets around a pair of nouns.

:: Cells can contain cells, and atoms of other auras as well:

[%hello 'world!']
:: [%hello 'world!']

> [[%in 0xa] 'cell']
:: [[%in 0xa] 'cell']


:: Why did this happen?

[6 [62 620]]
:: [6 62 620]

[6 62 620]
:: [6 62 620]

:: [6 [62 620]] and [6 62 620] are considered equivalent in Hoon. A cell must be a pair, which means there are always exactly two nouns in it. Whenever cell brackets are omitted so that visually there appears to be more than two child nouns, it is implicitly understood that the right-most nouns constitute a cell.


:: [6 [62 620]] and [[6 62] 620], on the other hand, are not equivalent.
:: If you look at them as binary trees you can see the difference:

::  [6 [62 620]]       [[6 62] 620]
::      .                  .
::     / \                / \
::    6   .              .   620
::       / \            / \
::     62   620        6   62


:: Noun Addresses

:: Nouns have a regular structure that can be exploited to give a unique address to each of its "sub-nouns". A sub-noun is a part of a noun that is itself a noun; e.g., [6 2] is a sub-noun of [[1 3] [6 2]]. We can also call these "noun fragments".

:: To define noun addresses we'll use recursion. The base case is trivial: address 1 of a noun is the entire noun. The generating case: if the noun at address n is a cell, then its head is at address 2n and its tail is at address 2n + 1. For example, if address 5 of some noun is a cell, then its head is at address 10 and its tail address 11.

:: Address 1 of the noun [[1 3] [6 2]] is the whole noun: [[1 3] [6 2]]. The head of the noun at address 1, [1 3], is at address 2 x 1, i.e., 2. The tail of the noun at address 1, [6 2], is at address (2 x 1) + 1, i.e., 3.

:: each noun can be understood as a binary tree. The following diagram shows the address of several nodes of the tree:

::            1
::          /   \
::         2     3
::        / \   / \
::       4   5 6   7
::                / \
::               14 15


:: For any unsigned integer n, +n evaluates to the fragment at address n.

+1:[22 [33 44]]
:: [22 33 44]

+2:[22 [33 44]]
:: 22

+3:[22 [33 44]]
:: [33 44]

+6:[22 [33 44]]
:: 33

+7:[22 [33 44]]
:: 44

+2:[['apple' %pie] [0b1101 0xdad]]
:: ['apple' %pie]

+5:[['apple' %pie] [0b1101 0xdad]]
:: %pie

+2:[[%one %two] [%three %four] [%five %six]]
:: [%one %two]

+3:[[%one %two] [%three %four] [%five %six]]
:: [[%three %four] %five %six]

+15:[[%one %two] [%three %four] [%five %six]]
:: %six
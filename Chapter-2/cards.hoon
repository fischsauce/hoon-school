:: !:

:: Using the Library

    :: So now that we have this (playing-cards.hoon) library, how do we actually use it? Let's look at a very simple say generator that takes advantage of what we built:

/+  playing-cards
:-  %say
|=  [[* eny=@uv *] *]
:-  %noun
(shuffle-deck:playing-cards make-deck:playing-cards eny)


:: If you save our the library as playing-cards.hoon in the lib directory, you can import the library with the /+ rune. 

:: Our above say -- let's call it cards.hoon -- imports our library in this way. It should be noted that /+ is not a Hoon rune, but instead a rune used by Ford, the Urbit build-system. 

:: When cards.hoon gets built, Ford will pull in the requested library and also build that. It will also create a dependency so that if playing-cards.hoon changes, this file will also get rebuilt.

:: Below /+ playing-cards, you have the standard say generator boilerplate that allows us to get a bit of entropy from arvo when the generator is run. Then we feed the entropy and a deck created by make-deck into shuffle-deck to get back a shuffled deck.

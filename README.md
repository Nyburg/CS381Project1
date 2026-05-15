# CS381 Project 1


## Sources

- https://www.erlang.org/doc/apps/stdlib/lists.html: used to understand lists:last/1 for selecting the final field after splitting a row.
- https://www.erlang.org/doc/apps/stdlib/re.html: Used to figure out the `re:replacement/4` behavior, and how escaped special characters are written in Erlang regex patterns.
- Also asked ChatGPT: "In Erlang regex what signals it to delete the rest of a line when I see a specific character?"
- Asked ChatGPT: "Why is my `remove_punctuation/1` function not working when it is identical to the `remove_superfluous/1`?" Realized I needed to add the `unicode` option because the spanish punctuation has to be represented that way.
- https://en.wikipedia.org/wiki/Bigram & https://www.baeldung.com/cs/n-gram: Preliminary research on how bigrams work and understanding what they are overall. 
- https://github.com/eejenner/Erlang-Assorted-Examples/blob/master/homework4.erl: Used this simple implementation of a bigram as an example to understand the basic pairing idea. This one is different from ours though since it is creating all possible word pair combos between two strings, instead of building bigrams from adjacent words coming directly after one another.
- Asked ChatGPT: "How should I be randomly selecting the next word in a bigram map but making sure that it's only looking at the top 10 most common?" This helped me figure out that I needed to use rand:uniform on a sublist with only the top 10 following words.
- https://www.erlang.org/doc/apps/stdlib/rand.html: Used some more Erlang docs, specifically rand to understand how rand:uniform/1 works for selecting random integers within a range. Went hand in hand with the wider range info I learned from ChatGPT directly above. 
- - https://www.erlang.org/doc/apps/stdlib/lists.html: Used to confirm `lists:reverse/1` for reversing the accumulated title words before joining them.
- https://www.erlang.org/doc/system/maps.html: Used to confirm `maps:is_key/2` for checking whether a generated word had already been used.
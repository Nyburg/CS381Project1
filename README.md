# CS381 Project 1


## Sources

- https://www.erlang.org/doc/apps/stdlib/lists.html: used to understand lists:last/1 for selecting the final field after splitting a row.
- https://www.erlang.org/doc/apps/stdlib/re.html: Used to figure out the `re:replacement/4` behavior, and how escaped special characters are written in Erlang regex patterns.
- Also asked ChatGPT: "In Erlang regex what signals it to delete the rest of a line when I see a specific character?"
- Asked ChatGPT: "Why is my `remove_punctuation/1` function not working when it is identical to the `remove_superfluous/1`?" Realized I needed to add the `unicode` option because the spanish punctuation has to be represented that way.
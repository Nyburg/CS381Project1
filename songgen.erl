-module(songgen).
-export([extract_title/1, remove_superfluous/1, remove_punctuation/1, remove_non_english/1, preprocess/1]).
%%-export([build_bigrams/1, next_word/2, generate_title/3]).

extract_title(Line)->
    Parts = binary:split(Line, <<"<SEP>">>, [global]),
    lists:last(Parts).
    
remove_superfluous(Title)->
    Pattern = "\\s*(\\(|\\[|\\{|/|\\\\|_|-|:|\"|`|\\+|=|feat\\.).*$",
    re:replace(Title, Pattern, <<>>, [{return, binary}]).

remove_punctuation(Title) ->
    Pattern = "[?\\x{00A1}!\\x{00BF}.;:&$*@%#|]",
    re:replace(Title, Pattern, <<>>, [global, unicode, {return, binary}]).

remove_non_english(Title) ->
    Pattern = "[^ a-zA-Z']",
    re:replace(Title, Pattern, <<>>, [global, {return, binary}]).


preprocess(Line) ->
    Title = extract_title(Line),
    NoSuperfluous = remove_superfluous(Title),
    NoPunctuation = remove_punctuation(NoSuperfluous),
    NoNonEnglish = remove_non_english(NoPunctuation),
    string:trim(NoNonEnglish).


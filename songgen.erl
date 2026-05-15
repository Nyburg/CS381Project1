-module(songgen).
-export([extract_title/1, remove_superfluous/1, remove_punctuation/1, remove_non_english/1, preprocess/1]).
-export([build_bigrams/1, next_word/2, generate_title/3]).

extract_title(Line)->
    Parts = binary:split(Line, <<"<SEP>">>, [global]),
    lists:last(Parts).
    
remove_superfluous(Title)->
    Pattern = "\\s*(\\(|\\[|\\{|/|\\\\|_|-|:|\"|`|\\+|=|\\bfeat\\.?\\b|\\bfeaturing\\b).*$",
    re:replace(Title, Pattern, <<>>, [caseless, {return, binary}]).

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

build_bigrams(Titles) ->
    lists:foldl(
        fun(Title, AccMap) ->
            Words = binary:split(string:lowercase(Title), <<" ">>, [global, trim_all]),
            add_title_bigrams(Words, AccMap)
        end,
        #{},
        Titles
    ).

add_title_bigrams([], Map) ->
    Map;
add_title_bigrams([Last], Map) ->
    add_bigram(Last, <<"$">>, Map);
add_title_bigrams([First, Second | Rest], Map) ->
    UpdatedMap = add_bigram(First, Second, Map),
    add_title_bigrams([Second | Rest], UpdatedMap).

add_bigram(First, Second, Map) ->
    InnerMap = maps:get(First, Map, #{}),
    CurrentCount = maps:get(Second, InnerMap, 0),
    UpdatedInnerMap = maps:put(Second, CurrentCount + 1, InnerMap),
    maps:put(First, UpdatedInnerMap, Map).

next_word(Word, Bigrams) ->
    case maps:get(Word, Bigrams, #{}) of
        EmptyMap when map_size(EmptyMap) =:= 0 ->
            <<"$">>;
        NextWords ->
            SortedWords = lists:sort(
                fun({_WordA, CountA}, {_WordB, CountB}) ->
                    CountA >= CountB
                end,
                maps:to_list(NextWords)
            ),
            TopWords = lists:sublist(SortedWords, min(10, length(SortedWords))),
            RandomIndex = rand:uniform(length(TopWords)),
            {NextWord, _Count} = lists:nth(RandomIndex, TopWords),
            NextWord
    end.

generate_title(Seed, Bigrams, MaxWords) ->
    UsedWords = maps:put(Seed, true, #{}),
    Words = generate_title_helper(Seed, Bigrams, MaxWords, 1, UsedWords, [Seed]),
    list_to_binary(string:join([binary_to_list(Word) || Word <- lists:reverse(Words)], " ")).

generate_title_helper(_CurrentWord, _Bigrams, MaxWords, Count, _UsedWords, Words)
    when Count >= MaxWords ->
    Words;

generate_title_helper(CurrentWord, Bigrams, MaxWords, Count, UsedWords, Words) ->
    NextWord = next_word(CurrentWord, Bigrams),
    case NextWord of
        <<"$">> ->
            Words;
        _ ->
            case maps:is_key(NextWord, UsedWords) of
                true ->
                    Words;
                false ->
                    UpdatedUsedWords = maps:put(NextWord, true, UsedWords),
                    generate_title_helper(
                        NextWord,
                        Bigrams,
                        MaxWords,
                        Count + 1,
                        UpdatedUsedWords,
                        [NextWord | Words]
                    )
            end
    end.
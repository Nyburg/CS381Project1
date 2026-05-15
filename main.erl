-module(main).
-export([main/0]).

main() ->
    {ok, Data} = file:read_file("tracks.txt"),
    Lines = binary:split(Data, <<"\n">>, [global, trim_all]),

    Titles = [songgen:preprocess(Line) || Line <- Lines],
    CleanTitles = [Title || Title <- Titles, Title =/= <<>>],

    Bigrams = songgen:build_bigrams(CleanTitles),

    io:format("Generated title from love: ~p~n", [songgen:generate_title(<<"love">>, Bigrams, 5)]),
    io:format("Generated title from you: ~p~n", [songgen:generate_title(<<"you">>, Bigrams, 5)]),
    io:format("Generated title from always: ~p~n", [songgen:generate_title(<<"always">>, Bigrams, 5)]),

    ok.
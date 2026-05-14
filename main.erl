-module(main).
-export([main/0]).

main() ->
    {ok, Data} = file:read_file("tracks.txt"),
    Lines = binary:split(Data, <<"\n">>, [global, trim_all]),
    Titles = [songgen:extract_title(Line) || Line <- Lines],
    print_first_titles(Titles, 10),
    
    ok.

print_first_titles(_, 0) ->
    ok;
print_first_titles([], _) ->
    ok;
print_first_titles([Title | Rest], Count) ->
    io:format("~s~n", [Title]),
    print_first_titles(Rest, Count - 1).
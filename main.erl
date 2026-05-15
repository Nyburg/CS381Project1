-module(main).
-export([main/0]).

main() ->
    InputFile =
        case init:get_plain_arguments() of
            [FileName | _] -> FileName;
            [] -> "tracks.txt"
        end,

    {ok, Data} = file:read_file(InputFile),
    Lines = binary:split(Data, <<"\n">>, [global, trim_all]),

    Titles = [songgen:preprocess(Line) || Line <- Lines],
    CleanTitles = [Title || Title <- Titles, Title =/= <<>>],

    Bigrams = songgen:build_bigrams(CleanTitles),

    {ok, SeedData} = file:read_file("seeds.txt"),
    Seeds = binary:split(SeedData, <<"\n">>, [global, trim_all]),

    GeneratedTitles = [
        songgen:generate_title(Seed, Bigrams, 5)
        || Seed <- Seeds
    ],

    Output = join_titles(GeneratedTitles),
    file:write_file("titles.txt", Output),

    io:format("Generated titles from ~s using seeds.txt saved to titles.txt~n", [InputFile]),

    ok.

join_titles([]) ->
    <<>>;
join_titles([Title]) ->
    Title;
join_titles([Title | Rest]) ->
    <<Title/binary, "\n", (join_titles(Rest))/binary>>.
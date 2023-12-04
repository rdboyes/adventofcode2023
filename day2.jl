using DataFrames
using TidierData
using TidierStrings

d = DataFrame(input = readlines("data/2.txt"))

tidy = @chain d begin
    @separate(input, (game, marbles), ":")
    @mutate(marble_list = split(marbles, r";|,"))
    @select(game, marble_list)
    flatten(:marble_list)
    @separate(marble_list, (extra, count, colour), " ")
    @mutate(game = as_integer(str_remove(game, "Game ")), count = as_integer(count))
    @select(game, colour, count)
end

p1 = @chain tidy begin
    @left_join(DataFrame(colour = ["red", "green", "blue"], max = [12, 13, 14]))
    @mutate(error = max < count)
    @group_by(game)
    @summarize(errors = sum(error))
    @filter(errors == 0)
    @summarize(sum_game = sum(game))
end

p2 = @chain tidy begin
    @group_by(game, colour)
    @summarize(max_by_colour = maximum(count))
    @summarize(power = prod(max_by_colour))
    @summarize(answer = sum(power))
end

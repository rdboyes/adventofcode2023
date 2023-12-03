using DataFrames
using TidierData

d = fill(".", 142, 142)
d[2:141, 2:141] = mapreduce(permutedims, vcat, split.(readlines("data/3.txt"), ""))
digit_list = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
digit_dot_list = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]

function check_location(d, row, col)   
    if !(d[row, col] in digit_list) || (d[row, col-1] in digit_list)
        return DataFrame(row = row, col = col, number = nothing, symbol = nothing, loc = nothing)
    end
    num_length = d[row, col+2] in digit_list && d[row, col+1] in digit_list ? 3 :
        d[row, col+1] in digit_list ? 2 : 1
    matrix_around = d[(row-1):(row+1), (col-1):(col+num_length)]
    symbol = [s for s in matrix_around if !(s in digit_dot_list)]
    return DataFrame(row = row, col = col, symbol = symbol,
        number = parse(Int, *(d[row, col:(col-1+num_length)]...)), 
        loc = findfirst(x -> x == "*", matrix_around))
end

answers = []

for i in 2:142
    for j in 2:142
        push!(answers, check_location(d, i, j))
    end
end

data = vcat(answers...)

p1 = @chain data begin
    @filter(!isnothing(number))
    @summarize(answer = sum(number))
end

p2 = @chain data begin
    @filter(!isnothing(number))
    @filter(symbol == "*")
    @mutate(numindex = CartesianIndex(row, col))
    @mutate(gear_location = numindex - CartesianIndex(2,2) + loc)
    @group_by(gear_location)
    @summarize(is_gear = n(), gear_ratio = prod(number))
    @filter(is_gear == 2)
    @summarize(answer = sum(gear_ratio))
end

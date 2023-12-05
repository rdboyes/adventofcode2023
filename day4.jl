using DataFrames
using TidierData
using CSV
using BenchmarkTools

function read_day4(path)
    tidy = @chain CSV.read(path, DataFrame, header = false, delim = ":") begin
        @separate(Column2, (winning_nums, my_nums), "|")
        @mutate(across(winning_nums:my_nums, x -> split.(x)))
        @mutate(wins = length.(intersect.(winning_nums_function, my_nums_function)))
        @select(card = Column1, wins)
    end

    return tidy
end

tidy = read_day4("data/4.txt")

function solve_p1(data)
    p1 = @chain data begin    
        @filter(wins != 0)
        @summarize(answer = sum(2 .^(wins .- 1)))
        @pull(answer)
    end

    return p1
end

solve_p1(tidy)

function solve_p2(data)
    copies = [1 for i in 1:196]

    for i in 1:196
        copies .+= [repeat([0], i); repeat([copies[i]], tidy.wins[i]); repeat([0], (196-i-tidy.wins[i]))]
    end

    return  sum(copies)
end

solve_p2(tidy)

@benchmark read_day4("data/4.txt")
@benchmark solve_p1(tidy)
@benchmark solve_p2(tidy)
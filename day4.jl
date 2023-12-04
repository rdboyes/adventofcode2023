using DataFrames
using TidierData
using CSV

tidy = @chain CSV.read("data/4.txt", DataFrame, header = false, delim = ":") begin
    @separate(Column2, (winning_nums, my_nums), "|")
    @mutate(across(winning_nums:my_nums, x -> split.(x)))
    @mutate(wins = length.(intersect.(winning_nums_function, my_nums_function)))
    @select(card = Column1, wins)
end

p1 = @chain tidy begin    
    @filter(wins != 0)
    @summarize(answer = sum(2 .^(wins .- 1)))
end

copies = [1 for i in 1:196]

for i in 1:196
    copies .+= [repeat([0], i); repeat([copies[i]], tidy.wins[i]); repeat([0], (196-i-tidy.wins[i]))]
end

p2 = sum(copies)
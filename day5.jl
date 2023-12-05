using DataFrames
using TidierData
using CSV

clean_input = function(path)
    data = readlines(path)

    seeds = @chain DataFrame(seed = data[1]) begin
        @separate(seed, (label, nums), ":")
        @mutate(nums = split.(nums))
        flatten(:nums)
        @mutate(nums = as_integer(nums))
        @select(seed_number = nums)
    end

    rules = @chain DataFrame(data = data[2:end]) begin
        @group_by(dataset = cumsum(data == ""))
        @slice(3:n())
        @ungroup()
        @separate(data, (to_start, from_start, length), " ")
        @transmute(across(dataset:length, x -> as_integer.(x)))
        @select(dataset = dataset_function, from = from_start_function, 
                to = to_start_function, len = length_function)
    end

    return (seeds, rules)
end

seeds, rules = clean_input("data/5.txt")

function seed_to_location(seed, rules)
    for i in 1:7
        rule = subset(rules, :dataset => x -> x .== i)
        seed_match = nothing
        for j in 1:nrow(rule)
            if rule.from[j] <= seed < rule.from[j] + rule.len[j]
                seed_match = rule.to[j] + (seed - rule.from[j])
            end
        end
        if !isnothing(seed_match)
            seed = seed_match
        end
    end
    return seed
end

minimum(map(x -> seed_to_location(x, rules), seeds.seed_number))

minimum(map(x -> seed_to_location(x, rules),
    vcat(collect.([seeds.seed_number[i]:(seeds.seed_number[i] + seeds.seed_number[i+1]) for i in 1:2:19])...)))
@chain DataFrame(a = [1,2,3]) begin
    @mutate(b = 2^(a-1))
end

# doesn't work
@chain DataFrame(a = [1,2,3]) begin
    @summarize(b = sum(2^(a-1)))
end

# works
@chain DataFrame(a = [1,2,3]) begin
    @summarize(b = sum(2 .^(a .- 1)))
end
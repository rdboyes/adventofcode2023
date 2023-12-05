@chain DataFrame(a = [1,2,3,4], b = ["a", "a", "b", "b"]) begin
    @group_by(b)
    @slice(1)
end

@chain DataFrame(a = [1,2,3,4], b = ["a", "a", "b", "b"]) begin
    @group_by(b)
    @slice(-2)
end
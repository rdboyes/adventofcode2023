d = readlines("data/1.txt")

∘̇(f,g) = x -> f(g.(x))

p1 = parse.(Int, (map(x -> x[1].captures[1] * x[end].captures[1], 
                           collect.(eachmatch.([r"([0-9])"], d))))) |> sum

regex_p2 = r"([0-9]|nine|eight|seven|six|five|four|three|two|one)"

strings =  Dict("one"   => "1",
                "two"   => "2",
                "three" => "3",
                "four"  => "4",
                "five"  => "5",
                "six"   => "6",
                "seven" => "7",
                "eight" => "8",
                "nine"  => "9")

p2 = parse.(Int, map(x -> replace(x[1].captures[1], strings...) *
                          replace(x[end].captures[1], strings...), 
              collect.(eachmatch.([regex_p2], d, overlap = true)))) |> sum
    
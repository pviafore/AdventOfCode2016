function getLowestCount(chars)
    dict = Dict()
    for char in chars
       dict[char] = get(dict, char, 0) + 1
    end
    return sort(collect(dict), by= tuple -> last(tuple))[1]
end

f = open("../day6.txt")
    lines = readlines(f)
    chars = map(s -> split(strip(s), ""), lines)
    reshaped = hcat(chars...)
    columns = map(x -> getLowestCount(reshaped[x,:]), 1:length(reshaped[:,1]))
    answer = *(map(c -> c[1], columns)...)
    println(answer)
close(f)
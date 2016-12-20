favorite_number = 1364

function isOdd(num)
    return num % 2 == 1
end


function get_number_of_bits(num, accum)
    if num == 0 then return accum end
    if isOdd(num) then return get_number_of_bits(bit32.rshift(num,1), accum+1) end
    return get_number_of_bits(bit32.rshift(num,1), accum)
end

function compute_is_wall(x,y)
    if x < 0 or y < 0 then return true end
    local num = x*x + 3*x + 2*x*y + y +y*y
    num = num + favorite_number   
    return isOdd(get_number_of_bits(num, 0))     
end


function filter(collection, f)
    local new = {}
    for k,v in pairs(collection) do
        if f(v) then table.insert(new, v) end
    end
    return new
end

eqmt = {__eq = function (k1, k2) return k1[1] == k2[1] and k1[2] == k2[2] end }

gridmeta = { __index = function(t,k) 
                         for key,val in pairs(t) do
                            if key == k then return t[key] end
                         end
                         t[k] = compute_is_wall(k[1], k[2])
                         return t[k]
                       end }
grid = {}
setmetatable(grid, gridmeta)
seen = {}
target = {31,39}
setmetatable(target, eqmt)

function get_manhattan_distance(x,y)
    return math.abs(target[1] - x) + math.abs(target[2] - y)
end

function is_seen(pos)
    for k,v in pairs(seen) do
        if k == pos then return true end
    end
    return false
end

function get_open_spaces(x,y,steps)
    local options =  { {x+1, y, steps+1}, {x-1, y, steps+1}, {x, y+1, steps+1}, {x, y-1, steps+1}}
    setmetatable(options[1], eqmt)
    setmetatable(options[2], eqmt)
    setmetatable(options[3], eqmt)
    setmetatable(options[4], eqmt)
    return filter(options, (function(v)  return not grid[v] and not is_seen(v); end))
end

count = 0
function main()
    options = {{1,1, 0}}
    setmetatable(options[1], eqmt)
    stopLooping = false
    while not stopLooping do
        position = options[1]
       
        if(not is_seen(position)) then
            count = count+1
            seen[position] = true
        end
        table.remove(options, 1)
        if(position[3] <= 49) then
            spaces = get_open_spaces(position[1], position[2], position[3])
            for _,space in pairs(spaces) do
                if(space == target) then
                    return space[3]
                end
                table.insert(options, space)
            end
        end
        stopLooping = (#options == 0)
    end
end

main()
print(count)

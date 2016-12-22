require 'digest'

input = "qljzarfv"

def is_valid_hash_character(hash, pos) 
    ('b'..'f').include? hash[pos]
end

Point = Struct.new(:x, :y) do
    def get_moves(input)
        md5 = Digest::MD5.new.update(input)
        hash = md5.hexdigest
        moves = Array.new
        moves << "U" if y != 1 and  is_valid_hash_character(hash, 0)
        moves << "D" if y != 4 and  is_valid_hash_character(hash, 1)
        moves << "L" if x != 1 and  is_valid_hash_character(hash, 2)
        moves << "R" if x != 4 and  is_valid_hash_character(hash, 3)
        moves
    end
end

def move_point(point, move)
    return Point.new(point.x, point.y-1) if move == "U"
    return Point.new(point.x, point.y+1) if move == "D"
    return Point.new(point.x-1, point.y) if move == "L"
    return Point.new(point.x+1, point.y) if move == "R"
end

def move_state(state, move)
    return State.new(move_point(state.point, move), state.passcode+move)
end

State = Struct.new(:point, :passcode) do
    def get_moves
        point.get_moves(passcode)
    end
end

states = [State.new(Point.new(1,1), input)]
while not states.empty? do
    current = states.shift
    if current.point == Point.new(4,4) then 
        puts current.passcode.slice(input.length, current.passcode.length)
        break
    end
    states = states + current.get_moves.map { |move| move_state(current, move)}
end
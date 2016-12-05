def parse_inputs():
    with open("day2.txt") as in_file:
        return in_file.read().split("\n")

def move_key(keypad, move):
    if move == "U":
        keypad["y"] = max(0, keypad["y"] - 1)
    elif move == "D":
        keypad["y"] = min(2, keypad["y"] + 1)
    elif move == "R":
        keypad["x"] = min(2, keypad["x"] + 1)
    elif move == "L":
        keypad["x"] = max(0, keypad["x"] - 1)

def get_key(keypad, directions):
    for direction in directions:
        move_key(keypad, direction)
    return get_keypad_key(keypad)

def get_keypad_key(keypad):
    return str(keypad["y"] * 3 + keypad["x"] + 1)

def main():
    directions_list = parse_inputs()
    keypad = {"x":1, "y": 1}
    keys = [get_key(keypad, directions) for directions in directions_list]
    return "".join(keys)

if __name__ == "__main__":
    print(main())




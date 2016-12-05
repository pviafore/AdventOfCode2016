def parse_inputs():
    with open("day2.txt") as in_file:
        return in_file.read().split("\n")


def get_edges():
    return [(0, 1), (1, 0), (2, -1), (3, 0), (4, 1), (-1, 2),
            (5, 2), (0, 3), (4, 3), (1, 4), (3, 4), (2, 5)]

def is_valid(keypad):
    return (keypad["x"], keypad["y"]) not in get_edges()

def move_key(keypad, move):
    if move == "U":
        keypad["y"] -= 1
    elif move == "D":
        keypad["y"] += 1
    elif move == "R":
        keypad["x"] += 1
    elif move == "L":
        keypad["x"] -= 1

def get_key(keypad, directions):
    for direction in directions:
        old_keypad = dict(keypad)
        move_key(keypad, direction)
        if not is_valid(keypad):
            keypad.update(old_keypad)
    return get_keypad_key(keypad)

def get_keypad_key(keypad):
    keypad_map = {(2, 0) : "1", (1, 1) : "2", (2, 1) : "3", (3, 1) : "4",
                  (0, 2) : "5", (1, 2) : "6", (2, 2) : "7", (3, 2) : "8",
                  (4, 2) : "9", (1, 3) : "A", (2, 3) : "B", (3, 3) : "C",
                  (2, 4) : "D"}
    return keypad_map[(keypad["x"], keypad["y"])]

def main():
    directions_list = parse_inputs()
    keypad = {"x":0, "y": 2}
    keys = [get_key(keypad, directions) for directions in directions_list]
    return "".join(keys)

if __name__ == "__main__":
    print(main())




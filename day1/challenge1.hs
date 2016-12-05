import Data.List.Split

data Turn = R | L
    deriving (Show)
data Move = Move { turn :: Turn, distance :: Int }
    deriving (Show)
data Direction = North | East | West | South
    deriving (Show, Eq)
data Coords = Coords { dir :: Direction, x :: Int, y :: Int}
    deriving (Show)

main =  do
    input <- readInput
    let final = processInput input
    let output = show (getDistance final)
    putStrLn output

readInput :: IO String
readInput = readFile "day1.txt"

splitOnComma = splitOn ", "

processInput :: String -> Coords
processInput input = foldl applyMove initial (makeMoves input)
    
makeMoves :: String -> [Move]
makeMoves input = map makeMove (splitOnComma input)

initial :: Coords
initial = Coords North 0 0  

makeMove :: String -> Move
makeMove str = Move (makeTurn (head str)) (read (tail str))

makeTurn :: Char -> Turn
makeTurn 'R' = R
makeTurn 'L' = L
makeTurn _ = R

applyMove :: Coords -> Move -> Coords
applyMove (Coords dir x y) (Move t d) = applyDistance (Coords dir x y) (rotate dir t) d

applyDistance :: Coords -> Direction -> Int -> Coords
applyDistance (Coords _ x y) dir dist | dir == North = Coords North x (y+dist)
                                      | dir == East  = Coords East (x+dist) y
                                      | dir == South = Coords South x (y-dist)
                                      | dir == West  = Coords West (x-dist) y                         

rotate :: Direction -> Turn -> Direction
rotate North R = East
rotate East R = South
rotate South R = West
rotate West R = North
rotate North L = West
rotate West L = South
rotate South L = East
rotate East L = North

getDistance :: Coords -> Int
getDistance (Coords _ x y) = abs(x) + abs(y) 
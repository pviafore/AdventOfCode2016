import Data.List.Split

data Turn = R | L
    deriving (Show)
data Move = Move { turn :: Turn, distance :: Int }
    deriving (Show)
data Direction = North | East | West | South
    deriving (Show, Eq)
data Coords = Coords { dir :: Direction, x :: Int, y :: Int}
    deriving (Show)

instance Eq Coords where 
     (Coords _ x1 y1) == (Coords _ x2 y2) = x1 == x2 && y1 == y2

data Position = Pos {coords :: Coords, path :: [Coords]}
    deriving (Show)
main =  do
    input <- readInput
    let position = processInput input
    let hq = findHeadquarters position
    let output = show (getDistance hq)
    putStrLn output

readInput :: IO String
readInput = readFile "day1.txt"

splitOnComma = splitOn ", "

processInput :: String -> Position
processInput input = foldl applyMove initial (makeMoves input)
    
makeMoves :: String -> [Move]
makeMoves input = map makeMove (splitOnComma input)

initial :: Position
initial = Pos (Coords North 0 0) [(Coords North 0 0)]  

makeMove :: String -> Move
makeMove str = Move (makeTurn (head str)) (read (tail str))

makeTurn :: Char -> Turn
makeTurn 'R' = R
makeTurn 'L' = L
makeTurn _ = R

applyMove :: Position -> Move -> Position
applyMove (Pos (Coords dir x y) p) (Move t d) = 
    let newCoord = (applyDistance (Coords dir x y) (rotate dir t) d)
    in (Pos newCoord (p ++ (makePath (Coords dir x y) newCoord)))

makePath :: Coords -> Coords -> [Coords]
makePath (Coords d1 x1 y1) (Coords d2 x2 y2)   | x1 < x2 = [Coords d2 x y2 | x <- [x1+1 .. x2]]
                                               | x2 < x1 = reverse ([Coords d2 x y2 | x <- [x2 .. x1-1]])
                                               | y1 < y2 = [Coords d2 x2 y | y <- [y1+1 .. y2]]
                                               | y2 < y1 = reverse ([Coords d2 x2 y | y <- [y2 .. y1-1]])
                                               | otherwise = [Coords d2 x2 y2]   

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

findHeadquarters :: Position -> Coords
findHeadquarters (Pos _ path) = findFirstDuplicate [] path

findFirstDuplicate :: [Coords] -> [Coords] -> Coords
findFirstDuplicate _ [] = Coords North 0 0
findFirstDuplicate seen (x:xs) | elem x seen == True = x
                               | otherwise = findFirstDuplicate (seen++[x]) xs 


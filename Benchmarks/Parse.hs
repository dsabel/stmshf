
module Main where
import System.Environment
import Data.List
import Data.Char
main = 
 do 
  (a:b:bs) <- getArgs
  content <- readFile a
  putStrLn (parse content b) 

parse xs title = 
 let ys = lines xs
     hdr = ys!!0
     mb = ys!!5
     tim = takeWhile (\x -> isDigit x || x == '.') $   (dropWhile (not . isDigit) $ (words (head $ filter ("Total" `isInfixOf` ) ys)!!3)++(words (head $ filter ("Total" `isInfixOf` ) ys)!!4))
 in title ++ ";" ++ (parseMB mb) ++ ";" ++ tim ++ ";s"

parseMB xs = concat $ intersperse ";" $ take 2 $ words xs 

 
 
#! /usr/bin/env stack
-- stack script --resolver lts-13.20

import System.Environment
import System.Process
import Data.Monoid

import Language.Java.Parser

main = do
    args <- getArgs
    go args

added :: String -> Integer
added line = read $ words line !! 0

removed :: String -> Integer
removed line = read $ words line !! 1

parseNumstat :: String -> (Integer, Integer)
parseNumstat out = (getSum $ fst sumOfChanges, getSum $ snd sumOfChanges)
    where
        lines' = lines out
        parseLine line = (Sum $ added line, Sum $ removed line)
        listOfChanges = map parseLine  lines'
        sumOfChanges = foldr (<>) (Sum 0, Sum 0) listOfChanges

go [commit_msg_file] = do
    out <- readProcess "git" ["diff", "-w", "--numstat", "HEAD"] ""
    print $ parseNumstat out
    print commit_msg_file

go _ = return ()


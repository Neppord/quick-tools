#! /usr/bin/env stack
-- stack script --resolver lts-13.20

import System.Environment
import System.Process
import Data.Monoid

import Language.Java.Parser

main = do
    args <- getArgs
    go args
git = readProcess "git"
numstat = git ["diff", "-w", "-z", "--numstat", "HEAD"] ""

getOldFile filepath = git ["cat-file", "-p", "HEAD:" <> filepath] ""
getNewFile = readFile

go [commit_msg_file] = do
    out <- numstat
    let (added, removed) = parseNumstat out
    writeFile commit_msg_file $ createMessage added removed 
go _ = return ()

createMessage added removed
  | added == removed = "r rename"
  | added == 0 = "r remove"
  | added > removed = "r extract"
  | otherwise = "r inline"

added :: String -> Integer
added line = read $ words line !! 0

removed :: String -> Integer
removed line = read $ words line !! 1

parseNumstat :: String -> (Integer, Integer)
parseNumstat out = case (sumOfChanges) of
    (Sum added, Sum removed) -> (added, removed)
    where
        lines' = lines out
        parseLine line = (Sum $ added line, Sum $ removed line)
        listOfChanges = map parseLine  lines'
        sumOfChanges = foldr (<>) (Sum 0, Sum 0) listOfChanges

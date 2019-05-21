#! /usr/bin/env stack
-- stack script --resolver lts-13.20

import System.Environment
import Language.Java.Parser

main = do
    args <- getArgs
    go args

go [commit_msg_file] = print commit_msg_file
go _ = return ()

main' = do
  [first, second] <- getArgs
  firstAst <- parser compilationUnit <$> readFile first
  secondAst <- parser compilationUnit <$> readFile second
  print $ firstAst == secondAst

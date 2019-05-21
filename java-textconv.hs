#! /usr/bin/env stack
-- stack script --resolver lts-13.21

import System.Environment
import Language.Java.Parser
import Language.Java.Pretty

main = do
  [filename] <- getArgs
  ast <- parser compilationUnit <$> readFile filename
  putStr $ case ast of
    Right tree -> prettyPrint tree
    Left _ -> ""
  putStr "\n"

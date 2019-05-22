#! /usr/bin/env stack
-- stack script --resolver lts-13.21

import System.Environment
import Language.Java.Parser
import Language.Java.Pretty

main = do
  [filename] <- getArgs
  text <- readFile filename
  let ast = parser compilationUnit text
  putStr $ case ast of
    Right tree -> (prettyPrint tree) <> "\n"
    Left _ -> text

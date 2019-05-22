#! /usr/bin/env stack
-- stack script --resolver lts-13.20

import System.Environment
import Language.Java.Parser

main = do
    args <- getArgs
    go args

go [commit_msg_file] = print commit_msg_file
go _ = return ()


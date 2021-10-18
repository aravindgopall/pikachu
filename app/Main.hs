module Main where

import Data.List.Split

import Options.Applicative
import System.Directory
import System.Command

import Opts

main :: IO ()
main = do
  cmd <- execParser argsInfo
  case cmd of
    Init -> initPika
    Pull str -> command_ [] "git" ["pull", str]
    Push str -> command_ [] "git" ["push", str]
    Checkout str -> storeStack *> command_ [] "git" ["checkout", str] *> restoreStack
    Commit (CommitOptions msg) -> command_ [] "git" ["commit", "-m", msg]
    Build (BuildOptions True m) -> command_ [] "stack" ["build", "--fast", "-j", show m]
    Build (BuildOptions False m) -> command_ [] "stack" ["build", "-j", show m]

currentBranch :: IO String
currentBranch = do
  dir <- getCurrentDirectory
  bs <- (head . lines) <$> readFile (dir <> "/.git/HEAD")
  return $ Prelude.last $ splitOn "refs/heads/" bs

storeStack :: IO ()
storeStack = do
  bs <- currentBranch
  command_ [] "mkdir" ["-p", ".pikachu/" <> bs]
  createDirectoryIfMissing True (".pikachu/" <> bs)
  command_ [] "cp" ["-r", ".stack-work", ".pikachu/" <> bs]

restoreStack :: IO ()
restoreStack = do
  bs <- currentBranch
  pe <- doesDirectoryExist (".pikachu/" <> bs)
  if pe
     then command_ [] "cp" ["-r", ".pikachu/" <> bs <> "/.stack-work", "./"]
     else pure ()

initPika :: IO ()
initPika =
  command_ [] "mkdir" ["-p", ".pikachu"]

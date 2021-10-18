module Opts where

import Options.Applicative

-- commands
-- init, build, push, pull, checkout
-- TODO: add options.
data Command
  = Build BuildOptions
  | Init
  | Push String
  | Pull String
  | Checkout String
  | Commit CommitOptions

data BuildOptions = BuildOptions
  { fast :: Bool
  , machines :: Int
  }

data CommitOptions = CommitOptions
  { msg :: String
  }

argsInfo :: ParserInfo Command
argsInfo = info argsP (fullDesc)

argsP :: Parser Command
argsP = subparser
      ( command "build" (info buildCommand ( progDesc "Build haskell code." ))
      <> command "init" (info (pure Init) (progDesc "Init Pikachu"))
      <> command "push" (info pushCommand (progDesc "git push"))
      <> command "pull" (info pullCommand (progDesc "git pull"))
      <> command "checkout" (info checkoutCommand (progDesc "git checkout"))
      <> command "commit" (info commitCommand (progDesc "git commit"))
       )

buildCommand :: Parser Command
buildCommand = Build <$> (BuildOptions
  <$> (switch ( long "fast" <> help "To build code with disabled optimizations." ))
  <*> (option auto ( short 'j' <> value 4 <> help "Number of cores to use." )))

commitCommand :: Parser Command
commitCommand = Commit <$> (CommitOptions
  <$> (strOption (short 'm' <> help "Commit msg")))

pushCommand :: Parser Command
pushCommand = Push . concat <$> (some (strArgument (metavar "Push info")))

pullCommand :: Parser Command
pullCommand = Pull . concat <$> (some (strArgument (metavar "Pull info")))

checkoutCommand :: Parser Command
checkoutCommand = Checkout . concat <$> (some (strArgument (metavar "checkout info")))

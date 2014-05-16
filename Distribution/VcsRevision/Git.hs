module Distribution.VcsRevision.Git ( getRevision ) where

import Control.Exception
import System.Process
import System.Exit

tryIO :: IO a -> IO (Either IOException a)
tryIO = try

-- | Nothing if we're not in a git repo, Just (hash,modified) if we're in a repo.
getRevision :: IO (Maybe (String, Bool))
getRevision = do
  res <- tryIO $ readProcessWithExitCode "git" ["log", "--format=%h", "-n", "1"] ""
  case res of
    Left ex -> return Nothing
    Right (ExitSuccess, commit, _) -> do
      (exit',_,_) <- readProcessWithExitCode "git" ["diff", "--quiet"] ""
      return $ Just (init commit, exit' /= ExitSuccess)
    _ -> return Nothing

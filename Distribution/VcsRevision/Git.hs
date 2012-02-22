module Distribution.VcsRevision.Git ( getRevision ) where

import System.Process
import System.Exit

-- | Nothing if we're not in a git repo, Just (hash,modified) if we're in a repo.
getRevision :: IO (Maybe (String, Bool))
getRevision = do
    (exit,commit,_) <- readProcessWithExitCode "git" ["log", "--format=%h", "-n", "1"] ""
    case exit of
        ExitSuccess -> do
          (exit',_,_) <- readProcessWithExitCode "git" ["diff", "--quiet"] ""
          return $ Just (init commit, exit' /= ExitSuccess)
        _ -> return Nothing

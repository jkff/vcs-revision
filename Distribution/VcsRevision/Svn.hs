module Distribution.VcsRevision.Svn ( getRevision ) where

import System.Process
import System.Exit
import Data.List

-- | Nothing if we're not in a svn repo, Just (revision,modified) if we're in a repo.
getRevision :: IO (Maybe (String, Bool))
getRevision = do
    (exit,info,_) <- readProcessWithExitCode "svn" ["info"] ""
    case exit of
        ExitSuccess -> do
          let prefix = "Last Changed Rev: "
          let rev = drop (length prefix) $ head $ filter (prefix `isPrefixOf`) (lines info)
          (_,out,_) <- readProcessWithExitCode "svn" ["st", "-q"] ""
          return $ Just (rev, out /= "")
        _ -> return Nothing

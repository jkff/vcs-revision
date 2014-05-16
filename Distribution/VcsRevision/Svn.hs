module Distribution.VcsRevision.Svn ( getRevision ) where

import Control.Exception
import System.Process
import System.Exit
import Data.List

tryIO :: IO a -> IO (Either IOException a)
tryIO = try

-- | Nothing if we're not in a svn repo, Just (revision,modified) if we're in a repo.
getRevision :: IO (Maybe (String, Bool))
getRevision = do
  res <- tryIO $  readProcessWithExitCode "svn" ["info"] ""
  case res of
    Left ex -> return Nothing
    Right (exit,info,_) -> case exit of
      ExitSuccess -> do
        let prefix = "Last Changed Rev: "
        let rev = drop (length prefix) $ head $ filter (prefix `isPrefixOf`) (lines info)
        (_,out,_) <- readProcessWithExitCode "svn" ["st", "-q"] ""
        return $ Just (rev, out /= "")
      _ -> return Nothing

module Distribution.VcsRevision.Mercurial ( getRevision ) where

import Control.Exception
import System.Process
import System.Exit

tryIO :: IO a -> IO (Either IOException a)
tryIO = try

-- | Nothing if we're not in a mercurial repo, Just (hash,modified) if we're in a repo.
getRevision :: IO (Maybe (String, Bool))
getRevision = do
  res <- tryIO $ readProcessWithExitCode "hg" ["identify", "-i"] ""
  case res of
    Left ex -> return Nothing
    Right (exit,out,_) -> case (exit,init out,last (init out)) of
      (ExitSuccess,hash,'+') -> return $ Just (init hash, True)
      (ExitSuccess,hash,_)   -> return $ Just (hash, False)
      (ExitFailure _,_,_)    -> return Nothing

module Distribution.VcsRevision.Mercurial ( getRevision ) where

import System.Process
import System.Exit

-- | Nothing if we're not in a mercurial repo, Just (hash,modified) if we're in a repo.
getRevision :: IO (Maybe (String, Bool))
getRevision = do
    (exit,out,_) <- readProcessWithExitCode "hg" ["identify", "-i"] ""
    case (exit,init out,last (init out)) of
        (ExitSuccess,hash,'+') -> return $ Just (init hash, True)
        (ExitSuccess,hash,_)   -> return $ Just (hash, False)
        (ExitFailure _,_,_)    -> return Nothing

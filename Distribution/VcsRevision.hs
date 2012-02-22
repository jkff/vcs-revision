-- | Example usage in a program that wants to access its own git version:
-- 
-- > {-# LANGUAGE TemplateHaskell #-}
-- > import Distribution.VcsRevision.Git
-- > import Language.Haskell.TH.Syntax
-- >
-- > showMyGitVersion :: String
-- > showMyGitVersion = $(do
-- >   v <- qRunIO getRevision
-- >   lift $ case v of
-- >     Nothing           -> "<none>"
-- >     Just (hash,True)  -> hash ++ " (with local modifications)"
-- >     Just (hash,False) -> hash)
--   
module Distribution.VcsRevision () where


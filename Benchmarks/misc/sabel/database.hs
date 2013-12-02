

module Main where

import Control.Concurrent
#ifdef SHF
import Control.Concurrent.SHFSTM
import Control.Concurrent.SHFSTM.TChan
#else
import Control.Concurrent.STM
#endif
import System.IO
import qualified Data.Map as Map


type DB  = TVar (Map.Map Integer (TVar Integer))

dblookup :: Integer -> DB -> STM Integer

dblookup i db =
   do
    _db <- readTVar db
    case Map.lookup i _db of 
      Nothing -> error $ "in lu "  ++ show i 
      Just tv  -> do
                   r <- readTVar tv
                   return r
                   
dbinsert :: Integer -> Integer -> DB -> STM ()
dbinsert i con db =
   do
    _db <- readTVar db
    tv <- newTVar con
    writeTVar db (Map.insert i tv _db)
                   

dbupdate i con db =
   do
    _db <- readTVar db
    case Map.lookup i _db of 
      Nothing -> dbinsert i con db
      Just tv  -> writeTVar tv con
        
dbdelete i db =
 do
  _db <- readTVar db
  case Map.lookup i _db of
    Nothing -> retry
    Just _  -> writeTVar db (Map.delete i _db)

numwork = 10
work = 1000    

main = 
 do
  tvars <- sequence $ replicate (fromInteger work) (newTVarIO (1::Integer)) 
  mvars <- sequence $ replicate (fromInteger numwork) (newEmptyMVar) 
  mp <- newTVarIO $ Map.fromAscList (zip [1..work] tvars)
  xs <- atomically (dblookup work mp)
  putStrLn (show $ xs)
  sequence_ [forkIO (worker mp sync) | (i,sync) <- zip [1..numwork] mvars]
  sequence_ [takeMVar m | m <- mvars]
  xs <- atomically (dblookup work mp)
  putStrLn (show $ xs)
  
worker db sync = 
 do
   atomically $
    do 
        con <- sequence [dblookup i db | i <- [1..(work-1)]]
        con2 <- dblookup work db
        dbupdate work (con2 + (sum $ con)) db
   putMVar sync ()
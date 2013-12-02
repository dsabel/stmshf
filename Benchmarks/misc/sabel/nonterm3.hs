module Main where

import Control.Concurrent
#ifdef SHF
import Control.Concurrent.SHFSTM
import Control.Concurrent.SHFSTM.TChan
#else
import Control.Concurrent.STM
#endif


main = 
 do
  tv <- newTVarIO 0
  s <- newEmptyMVar
  forkIO $ fast tv s 
  forkIO $ slow tv s
  threadDelay 10000
  takeMVar s
  putStrLn "got first"
  takeMVar s
  putStrLn "got second"
  
fast tv s = 
 do
  atomically $ 
   do
    x <- readTVar tv
    if x == 0 then
      do wait 
     else
      return ()
  putMVar s ()
  
slow tv s =
 do
  threadDelay 100
  sequence_ (replicate 10000 (atomically $ writeTVar tv 1   ))
  putMVar s ()
   
   
wait = do wait   
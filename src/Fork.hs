{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE RebindableSyntax #-}
module Fork where

import qualified Control.Concurrent as C
import Control.Concurrent (MVar, ThreadId)
import Unsafe.Coerce
import Data.Unrestricted.Linear
import qualified System.IO.Linear as L
import Control.Functor.Linear
import Prelude.Linear
import qualified Prelude as P
import qualified Control.Monad as P


fork :: ((a ⊸ L.IO b) %1 -> L.IO ()) %1 -> L.IO (b -> L.IO a)
fork action = do
  (inner1, inner2) <- dup <$> newEmptyMVar
  (outer1, outer2) <- dup <$> newEmptyMVar
  forkLIO (action (\a -> putMVar (unur inner1) a >> readMVar (unur outer1)))
  return (\b -> putMVar (unur outer2) b >> readMVar (unur inner2))

test :: IO ()
test = L.withLinearIO $ do
  swap'' <- fork (\swap' -> swap' (1 :: Int) >>= printL)
  swap'' "hi" >>= printL
  pure $ move ()















newEmptyMVar :: L.IO (Ur (MVar a))
newEmptyMVar = unsafeCoerce $ P.fmap Ur C.newEmptyMVar

readMVar :: MVar a %1 -> L.IO a
readMVar = unsafeCoerce C.readMVar

putMVar :: MVar a %1 -> a %1 -> L.IO ()
putMVar = unsafeCoerce C.putMVar

forkLIO :: L.IO () %1 -> L.IO ()
forkLIO = unsafeCoerce (P.void P.. C.forkIO)

printL :: forall a. Show a => a %1 -> L.IO ()
printL = unsafeCoerce (print @a)

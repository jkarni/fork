{-# LANGUAGE GADTs #-}
module U where

import Prelude
data U a where
   U :: a -> U a

u :: Int -> U Int
u _ = U 5

{-# LANGUAGE CPP               #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE Trustworthy       #-}

module Monad
       ( Monad ((>>=), return)
       , MonadPlus (..)

       , (=<<)
       , (>=>)
       , (<=<)
       , (>>)
       , forever

       , join
       , mfilter
       , filterM
       , mapAndUnzipM
       , zipWithM
       , zipWithM_
       , foldM
       , foldM_
       , replicateM
       , replicateM_
       , concatMapM

       , guard
       , when
       , unless

       , whenJust
       , whenJustM

       , liftM
       , liftM2
       , liftM3
       , liftM4
       , liftM5
       , liftM'
       , liftM2'
       , ap

       , (<$!>)
       ) where

import           Base                (seq)
import           Control.Applicative (Applicative)
import           Data.Foldable       (for_)
import           Data.List           (concat)
import           Data.Maybe          (Maybe, maybe)

#if (__GLASGOW_HASKELL__ >= 710)
import           Control.Monad       hiding ((<$!>))
#else
import           Control.Monad
#endif

concatMapM :: Monad m => (a -> m [b]) -> [a] -> m [b]
concatMapM f xs = liftM concat (mapM f xs)

liftM' :: Monad m => (a -> b) -> m a -> m b
liftM' = (<$!>)
{-# INLINE liftM' #-}

liftM2' :: Monad m => (a -> b -> c) -> m a -> m b -> m c
liftM2' f a b = do
  x <- a
  y <- b
  let z = f x y
  z `seq` return z
{-# INLINE liftM2' #-}

(<$!>) :: Monad m => (a -> b) -> m a -> m b
f <$!> m = do
  x <- m
  let z = f x
  z `seq` return z
{-# INLINE (<$!>) #-}

whenJust :: Applicative f => Maybe a -> (a -> f ()) -> f ()
whenJust = for_
{-# INLINE whenJust #-}

whenJustM :: Monad m => m (Maybe a) -> (a -> m ()) -> m ()
whenJustM mm f = maybe (return ()) f =<< mm
{-# INLINE whenJustM #-}


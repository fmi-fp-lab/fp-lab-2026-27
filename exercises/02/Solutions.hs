{-# LANGUAGE RankNTypes #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
-- cover all cases!
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}
-- warn about incomplete patterns v2
{-# OPTIONS_GHC -fwarn-incomplete-uni-patterns #-}
-- write all your toplevel signatures!
{-# OPTIONS_GHC -fwarn-missing-signatures #-}
-- use different names!
{-# OPTIONS_GHC -fwarn-name-shadowing #-}
-- use all your pattern matches!
{-# OPTIONS_GHC -fwarn-unused-matches #-}

{-# HLINT ignore "Eta reduce" #-}

module HOF where

import Control.Monad (ap, join, liftM2)
import Control.Monad.Fix (fix)
import Prelude hiding (const, curry, id, log, map, on, swap, uncurry, until, ($), (.))

-- >>> applyTwice (+1) 5
-- 7

applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

id :: a -> a
id x = x

($) :: (a -> b) -> a -> b
f $ a = f a
infixr 0 $

data Tuple a b = MkTuple a b
  deriving (Show)

sumTuple :: Tuple Int Int -> Int
sumTuple (MkTuple a b) = a + b

fstTuple :: Tuple a b -> a
fstTuple (MkTuple a _) = a

sndTuple :: Tuple a b -> b
sndTuple (MkTuple _ b) = b

-- TASK:
-- Take two arguments and return the first.
-- This is called const because if we think of it as a function
-- on one argument x, it returns a function that when called, always returns x
-- It is also practically always used partially applied.

-- >>> const 5 6
-- 5
-- >>> applyTwice (const 42) 1337
-- 42

const :: a -> b -> a
const x _ = x

-- TASK:
-- Compose two functions, very useful very often
-- there's a builtin (.) for this - the dot mimics mathematical notation f∘g

-- >>> let f = compose (+3) (*5) in f 4
-- 23
-- >>> let f = compose (*5) (+5) in f 4
-- 45

compose :: (b -> c) -> (a -> b) -> a -> c
compose f g x = f (g x)

-- TASK:
-- Iterate a function f n times over a base value x.

-- >>> iterateN (+1) 1 10
-- 11
-- >>> iterateN (*2) 1 10
-- 1024

iterateN :: (a -> a) -> a -> Integer -> a
iterateN f x n
  | n <= 0 = x
  | otherwise = iterateN f (f x) (n - 1)

-- TASK:
-- Swap the two elements of a tuple

-- >>> swap $ MkTuple 42 69
-- MkTuple 69 42

swap :: Tuple a b -> Tuple b a
swap (MkTuple a b) = MkTuple b a

-- TASK:
-- Apply a function to only the first component of a tuple

-- >>> first (*2) $ MkTuple 21 1337
-- MkTuple 42 1337

first :: (a -> b) -> Tuple a c -> Tuple b c
first f (MkTuple a c) = MkTuple (f a) c

-- TASK:
-- Convert a function operating on a tuple, to one that takes two arguments.
-- Called Curry after Haskell Curry - inventor of lambda calculus.
-- (Guess where the language gets its name from, ексди)

-- >>> curry (\(MkTuple x y) -> x * y) 23 3
-- 69

curry :: (Tuple a b -> c) -> a -> b -> c
curry h a b = h (MkTuple a b)

-- TASK:
-- Convert a two argument function, to one that takes a Tuple.

-- >>> uncurry (\x y -> x + y) $ MkTuple 23 46
-- 69

uncurry :: (a -> b -> c) -> Tuple a b -> c
uncurry f (MkTuple a b) = f a b

-- TASK:
-- > p `on` f
-- Implement a combinator that allows you to "preapply" a function f on the arguments of a function p

-- >>> let maxOnFirst = max `on` fstTuple in maxOnFirst (MkTuple 1 20) (MkTuple 2 100000)
-- 2
-- >>> let maxOnSum = max `on` sumTuple in maxOnSum (MkTuple 20 39) (MkTuple 12 34)
-- 59

on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
on p f x y = p (f x) (f y)

-- TASK:
-- Execute a function, until the result starts sastifying a given predicate

-- >>> until (>1000) (*7) 4
-- 1372

until :: (a -> Bool) -> (a -> a) -> a -> a
until p f x = if p x then x else until p f (f x)

if' :: Bool -> a -> a -> a
if' p x y = if p then x else y

-- TASK:
-- Apply two different functions to the two different arguments of a tuple
-- Think about what the type should be.

mapTuple :: (a -> b) -> (c -> d) -> Tuple a c -> Tuple b d
mapTuple f g (MkTuple a c) = MkTuple (f a) (g c)

data Nat
  = Zero
  | Succ Nat
  deriving (Show)

-- Look at addNat and multNat from last time.
--
-- addNat :: Nat -> Nat -> Nat
-- addNat Zero m = m
-- addNat (Succ n) m = Succ (addNat n m)
--
-- multNat :: Nat -> Nat -> Nat
-- multNat Zero _ = Zero
-- multNat (Succ n) m = addNat m (multNat n m)
--
-- They look very similar...

-- TASK:
-- Can you implement a general enough higher-order function (called `foldNat` here), such that you can then use to
-- implement both of `addNat` and `multNat` by passing suitable arguments? What are those arguments?
--
foldNat :: r -> (r -> r) -> Nat -> r
foldNat z _ Zero = z
foldNat z s (Succ n) = s (foldNat z s n)

-- TASK:
-- If your function is "good enough" you should also be able to implement exponentiation using it.

-- Examples using foldNat
addNat :: Nat -> Nat -> Nat
addNat n m = foldNat m Succ n

multNat :: Nat -> Nat -> Nat
multNat n m = foldNat Zero (addNat m) n

expNat :: Nat -> Nat -> Nat
expNat n m = foldNat one (multNat n) m
 where
  one = Succ Zero

-- TASK:
-- Can you also implement the following function using your foldNat? If not, (try to) modify your function so you can.

natToInteger :: Nat -> Integer
natToInteger = foldNat 0 (+ 1)

-- TASK:
-- Can you also implement the following "predecessor" function using it? Yes/No, and why?
-- If not, can you think of a foldNat' :: ??? with a different type signature, which would allow you to implement predNat?
-- predNat :: Nat -> Nat
-- predNat Zero = Zero
-- predNat (Succ n) = n

foldNat' :: r -> (Nat -> r -> r) -> Nat -> r
foldNat' z _ Zero = z
foldNat' z s (Succ n) = s n (foldNat' z s n)

predNat :: Nat -> Nat
predNat = foldNat' Zero const

{-# LANGUAGE RankNTypes #-}
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

module HOF where

import Prelude hiding (const, curry, id, log, map, on, swap, uncurry, until, ($), (.))

-- TODO:
-- - remind about progress/problems with homework
-- - remind about formatter and early feedback PRs
-- - remind about the next homework
--
-- TODO: talk about
-- - currying
-- - ($), (.), and types
-- - sections
-- - guards
-- - lambdas and desugaring function definitions
-- - higher-order functions and polymorphism
-- - `let` and `where`
-- - combinators

-- TODO: implement
-- A pair type for the tuple exercises.
data Tuple a b = MkTuple a b
  deriving (Show)

-- TODO: implement
sumTuple :: Tuple Int Int -> Int
sumTuple = undefined

-- TODO: implement both, and show the C++ equivalent.
fstTuple :: Tuple a b -> a
fstTuple = undefined

sndTuple :: Tuple a b -> b
sndTuple = undefined

-- TASK:
-- Take two arguments and return the first.
-- This is called const because partial application returns a constant function.

-- >>> const 5 6
-- 5
-- >>> applyTwice (const 42) 1337
-- 42

const :: a -> b -> a
const = undefined

-- TASK:
-- Compose two functions.
-- There is a builtin `(.)`; the dot follows mathematical notation f∘g.

-- >>> let f = compose (+3) (*5) in f 4
-- 23
-- >>> let f = compose (*5) (+5) in f 4
-- 45

compose :: (b -> c) -> (a -> b) -> a -> c
compose = undefined

-- TASK:
-- Iterate a function n times over a base value.

-- >>> iterateN (+1) 1 10
-- 11
-- >>> iterateN (*2) 1 10
-- 1024

iterateN :: (a -> a) -> a -> Integer -> a
iterateN = undefined

-- TASK:
-- Swap the two elements of a tuple.

-- >>> swap $ MkTuple 42 69
-- MkTuple 69 42

swap :: Tuple a b -> Tuple b a
swap = undefined

-- TASK:
-- Apply a function to only the first component of a tuple.

-- >>> first (*2) $ MkTuple 21 1337
-- MkTuple 42 1337

first :: (a -> b) -> Tuple a c -> Tuple b c
first = undefined

-- TASK:
-- Convert a function on a tuple to a function with two arguments.

-- >>> curry (\(MkTuple x y) -> x * y) 23 3
-- 69

curry :: (Tuple a b -> c) -> a -> b -> c
curry = undefined

-- TASK:
-- Convert a two-argument function to a function on a tuple.

-- >>> uncurry (\x y -> x + y) $ MkTuple 23 46
-- 69

uncurry :: (a -> b -> c) -> Tuple a b -> c
uncurry = undefined

-- TASK:
-- Implement the `on` combinator.
-- `p `on` f` applies f to both arguments before applying p.

-- >>> let maxOnFirst = max `on` fstTuple in maxOnFirst (MkTuple 1 20) (MkTuple 2 100000)
-- 2
-- >>> let maxOnSum = max `on` sumTuple in maxOnSum (MkTuple 20 39) (MkTuple 12 34)
-- 59

on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
on = undefined

-- TASK:
-- Execute a function until the result satisfies a predicate.

-- >>> until (>1000) (*7) 4
-- 1372

until :: (a -> Bool) -> (a -> a) -> a -> a
until = undefined

-- TASK:
-- Apply two functions to the two components of a tuple.

mapTuple :: (a -> b) -> (c -> d) -> Tuple a c -> Tuple b d
mapTuple = undefined

data Nat
  = Zero
  | Succ Nat
  deriving (Show)

-- TODO:
-- Reuse the definitions of addNat and multNat from the previous exercise.

-- TASK:
-- Define a fold over Nat, then use it to implement addNat and multNat.
-- Consider which arguments represent the zero case and the successor step.

-- foldNat :: ???
-- foldNat = undefined

-- TASK:
-- Use the fold to implement exponentiation.

-- expNat :: Nat -> Nat -> Nat
-- expNat = undefined

-- TASK:
-- Use the fold to implement conversion to Integer.

-- natToInteger :: Nat -> Integer
-- natToInteger = undefined

-- TASK:
-- Explain whether the same fold can implement predecessor.
-- If not, define a foldNat' with a suitable type and use it for predNat.

-- predNat :: Nat -> Nat
-- predNat = undefined

-- vim: set fdm=marker:
{-# LANGUAGE BangPatterns #-}
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
{-# HLINT ignore "Redundant lambda" #-}
{-# HLINT ignore "Use lambda-case" #-}
{-# HLINT ignore "Use map" #-}

module Lazy where

import Prelude hiding (cycle, foldl, foldl', foldr, repeat, scanl)

-- TODO:
-- (boolean blindness)
-- https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/
-- (a -> Maybe b) VS (a -> Bool, a -/-> b) -- (funny symbol for a partial function)
-- thunks -- delayed computation, replaced when done; memoization incarnate
-- :print, :sprint
-- (don't forget type annotations; sometimes unreliable, different results between ghc versions)
-- (maybe try `:set -XMonomorphismRestriction` for some (polymorphic) examples)
-- when do we "need" to evaluate something? case matches!
-- pattern-matching desugaring (Nat, isZero, tuples)
-- how much do we need to evaluate it?
-- WHNF (the least that we need to do to continue forward)
-- infinite structures (again)
-- Stream, but we will use [] with asserts*
-- error "banica"
-- show the definition of take?
-- Debug.Trace

data Stream a = Cons a (Stream a)

-- foldr, foldl, stack space
--
-- {seq :: a -> b -> b}
-- {seq a b} - "evaluate a and b together" - no enforced order, but usually used to mean a before b
-- {seq a b} terminates iff a terminates ("terminates" meaning that it evaluates to something)
--
-- very detailed SO answer describing seq in more detail:
-- https://stackoverflow.com/a/66965677
--
-- Quoting: <<EOQ
-- A note on evaluation order: the expression {seq a b} does not guarantee that {a} will be evaluated before {b}.
-- The only guarantee given by {seq} is that the both {a} and {b} will be evaluated before seq returns a value.
-- In particular, this means that {b} *may* be evaluated before {a}.
-- It also means that if you entirely ignore the result of {seq a b}, neither {a} nor {b} will be evaluated,
-- for example in {const 5 (seq undefined undefined)}.
-- EOQ

foldl :: (b -> a -> b) -> b -> [a] -> b
foldl _ acc [] = acc
foldl f acc (x : xs) = foldl f (f acc x) xs

-- NOTE: the bang on the accumulator forces it on every step,
--       so the thunk chain from foldl never builds up

foldl' :: (b -> a -> b) -> b -> [a] -> b
foldl' _ acc [] = acc
foldl' f acc (x : xs) = f acc x `seq` foldl' f (f acc x) xs

-- NOTE: the same thing, but with a bang pattern instead of seq

foldl'' :: (b -> a -> b) -> b -> [a] -> b
foldl'' _ acc [] = acc
foldl'' f !acc (x : xs) = foldl'' f (f acc x) xs

-- NOTE: bang patterns
-- A bang in a pattern forces the matched value to WHNF (one step only) before
-- the body runs. It is sugar for {seq}: {f !x = e} is {f x = x `seq` e}.
-- A bang may appear in a function argument (see {foldl'}), in a {let}, and in
-- a {case}. On a list it forces the spine, not the elements.

bangInLet :: Integer -> Integer
bangInLet n =
  let !m = n * n
   in m + 1

-- >>> bangInLet 6
-- 37

-- NOTE: from the previous exercises - the base case comes first

foldr :: b -> (a -> b -> b) -> [a] -> b
foldr nv _ [] = nv
foldr nv f (x : xs) = f x $ foldr nv f xs

length' :: [a] -> Integer
length' = foldl (\acc _ -> acc + 1) 0

-- >>> length' [1,2,3]
-- 3

-- length (1 : 2 : 3 : [])
-- foldl' (\acc _ -> acc + 1) 0 (1 : 2 : 3 : [])
-- foldl' _ ((\acc _ -> acc + 1) 0 1) (2 : 3 : [])
-- foldl' _ (0 + 1) (2 : 3 : [])
-- foldl' _ (1 + 1) (3 : [])
-- foldl' _ (2 + 1) ([])
-- 3

reverseAndMap' :: (a -> b) -> [a] -> [b]
reverseAndMap' f = foldl (\ys x -> f x : ys) []

-- map' (1+) [1,2,3]
-- foldl (\ys x -> f x : ys) [] [1,2,3]
-- foldl (\ys x -> f x : ys) ((1+) 1 : []) [2,3]
-- foldl (\ys x -> f x : ys) ((1+) 2 : ((1+) 1 : [])) [3]
-- foldl (\ys x -> f x : ys) ((1+) 3 : ((1+) 2 : ((1+) 1 : []))) []
-- ((1+) 3 : ((1+) 2 : ((1+) 1 : [])))

-- foldr [] (\x ys -> f x : ys) [1,2,3]
-- (\x ys -> f x : ys) 1 $ foldr [] (\x ys -> f x : ys) [2,3]
-- f 1 : foldr [] (\x ys -> f x : ys) [2,3]
-- f 1 : f 2 : foldr [] (\x ys -> f x : ys) [3]
-- f 1 : f 2 : f 3 : foldr [] (\x ys -> f x : ys) []
-- f 1 : f 2 : f 3 : []

-- TODO:
-- seq the acc
-- bang the acc

-- TASK:
-- Infinitely repeat a value

-- >>> take 4 $ repeat 'a'
-- "aaaa"

repeat :: a -> [a]
repeat = undefined

-- TASK:
-- A list of all the natural numbers.

-- >>> take 10 nats
-- [0,1,2,3,4,5,6,7,8,9]

nats :: [Integer]
nats = undefined

-- TASK:
-- Generate an infinite list of numbers, starting with the given number, with the given interval between each number.

-- >>> take 10 $ fromThen 0 1
-- [0,1,2,3,4,5,6,7,8,9]
-- >>> take 20 $ fromThen 0 1
-- [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
-- >>> take 10 $ fromThen 4 9
-- [4,13,22,31,40,49,58,67,76,85]
-- >>> take 10 $ fromThen 0 (-10)
-- [0,-10,-20,-30,-40,-50,-60,-70,-80,-90]

fromThen :: Integer -> Integer -> [Integer]
fromThen = undefined

-- TASK:
-- Implement a list of all the factorial numbers
-- Use a where or let to "cache" the current number, so we don't do all the multiplications every time.
-- i.e. if we've already calculated 5!, we can simply multiply the result by 6, we don't need to calculate 5! again.

-- >>> take 10 facts
-- [1,1,2,6,24,120,720,5040,40320,362880]

facts :: [Integer]
facts = undefined
  where
    go = undefined

-- TASK:
-- "Caching foldl"
-- It's sometimes useful to have all the "intermediate" results of a fold. It's also helpful for debugging sometimes.
-- Implement a version of foldl that returns all of the intermediate results it has.
-- These are called "scans" in the Haskell standard library.

-- >>> scanl (+) 0 [1..10]
-- [0,1,3,6,10,15,21,28,36,45,55]

scanl :: (b -> a -> b) -> b -> [a] -> [b]
scanl = undefined

-- TASK:
-- Use scanl to implement facts.

-- >>> take 11 factsScanl
-- [1,1,2,6,24,120,720,5040,40320,362880,3628800]

factsScanl :: [Integer]
factsScanl = undefined

-- TASK:
-- Implement a list of all the fibonacci numbers.
-- Use the following idea:
-- The fibonacci numbers start with 0 1
-- To generate the next fibonacci number, we need to sum the previous two, so assuming we already have
-- fibs :: [Integer]
-- that would mean summing the head of fibs with the head of the tail of fibs
-- zipWith will be useful here.

-- >>> take 10 fibs
-- [0,1,1,2,3,5,8,13,21,34]

fibs :: [Integer]
fibs = undefined

-- TASK:
-- Idea:
-- We can get all the primes with the following algorithm.
-- Let's start with all the numbers >=2
-- The current number - call it x - is prime (this is true in the beginning - x = 2 is prime) - leave it in our list
-- All of the other numbers that are divisible by x aren't prime - filter them out
-- This is called the sieve of Eratosthenes
-- Implement this for a given input list
-- Now all we need to do is apply it to all the natural numbers >=2 to get a list of all the primes.

-- >>> take 10 $ primes
-- [2,3,5,7,11,13,17,19,23,29]
-- >>> take 20 $ primes
-- [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71]

primes :: [Integer]
primes = undefined
  where
    eratosthenes :: [Integer] -> [Integer]
    eratosthenes = undefined

-- TASK:
-- Infinitely repeat a list

-- >>> take 7 $ cycle [1,2,3]
-- [1,2,3,1,2,3,1]

cycle :: [a] -> [a]
cycle = undefined

-- TASK:
-- Let's consider the following problem:
-- We have a "circle" of n people. We have an integer k.
-- We repeat the following procedure, starting from the first person, until there is only one left:
--
-- "Kill" the kth person. Repeat this, "starting" from the k+1th person, i.e. we start indexing from the k+1th person.
--
-- Example execution for n = 5, k = 2:
-- 1 2 3 4 5 (start)
-- 1 2 4 5 (we kill 3, since 0 + 2 = 2)
-- 2 4 5 (we kill 1, since 4 + 2 = 6, circling back to 1)
-- 2 4
-- 4
--
-- The question is, given arguments n and k, what's the number of the final person left. (4 in the example above)
--
-- This is called the josephus problem - see https://en.wikipedia.org/wiki/Josephus_problem.
--
-- Your task is to implement {jos :: Integer -> Int -> Integer}
-- which takes n and k, and returns the last surviving person.
--
-- Your hint is to use `cycle` to express our circle, and then to drop and filter things from it.
-- E.g. the representation of our circle for n = 5 would be [0,1,2,3,4,0,1,2,3,4,0,1,2,3,4...]

-- >>> jos 5 2
-- 4
-- >>> jos 10 4
-- 3
-- >>> jos 10 8
-- 7
-- >>> map (\(x,y) -> (x, y, jos x y)) [(x, y) | x <- [2..5], y <- [2..5]]
-- [(2,2,2),(2,3,1),(2,4,2),(2,5,1),(3,2,2),(3,3,2),(3,4,1),(3,5,1),(4,2,1),(4,3,2),(4,4,2),(4,5,3),(5,2,4),(5,3,1),(5,4,2),(5,5,4)]

jos :: Integer -> Int -> Integer
jos = undefined
  where
    -- figure out what this function should do based only on the types and the name
    -- I think there's only one valid type safe implementation of this
    -- ask me if you're confused
    -- this function exists in base but with Bool instead of Maybe
    untilJust :: (a -> Maybe b) -> (a -> a) -> a -> b
    untilJust = undefined
    -- the procedure which actually does the removal
    go :: [Integer] -> [Integer]
    go = undefined

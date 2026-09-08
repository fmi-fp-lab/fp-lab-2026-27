-- {{{ Pragmas

-- NOTE: read up more here - https://wiki.haskell.org/Language_Pragmas

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

{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
-- disable some hints that spoil the easy tasks
{-# HLINT ignore "Use even" #-}

-- }}}

module Intro where

---------------------------------

-- NOTE: me
-- Pavel Atanasov, contact info in README
-- (бивш) СИ, не млъква

-- WARN: administrivia
-- ask about git knowledge
--   - collect GitHub usernames, provision in-class org forks
-- ask about uni programs
-- github repo - https://github.com/fmi-fp-lab/fp-lab-2026-27

-- TODO: exposition
--
-- throw away most of the terminology you know from other languages
--
--   (Typed) Functional Programming is
--     - Defining Datatypes To Represent Problems
--     - Defining Functions To Create New Data From Old

--
-- garbage collection
-- expressive static types
-- no null everywhere!
-- sum types

-- pattern matching!
-- higher-order functions!
-- lazy - a boon and a curse
-- no arbitrary IO
-- no mutations
-- value/"pipeline" oriented
-- concise, very modular

-- all in all -
-- the language allows you to

-- * make it harder for yourself to write garbage

--   * very enjoyable to work with - I'm dumb and so I let my compiler do most of my work for me
--   * used for things that **really** shouldn't break :) - e.g. banks, military

-- * be free in what level of abstraction you want to work on

--   * you can write rather low level C-like code
--   * but you can also almost directly express some mathematical concepts in it
--   * you can save yourself *a lot* of boilerplate
--

-- disadvantages
-- not ultra popular:

-- * harder to get a job

-- * some libraries might be outdated/not extremely optimised

-- * there aren't obvious "best ways" to do things sometimes

-- learning curve is very steep at the beginning - especially when you are coming from an "imperative" and/or untyped background
-- used a lot for things of questionable morality (finance, blockchain, etc)

-- myths
-- not a silver bullet
-- it's still a tool, and tools require proper usage (https://pbs.twimg.com/media/E7Kc0OhVUAAV0xz?format=jpg&name=small)
-- monads aren't hard (in haskell), they're only scary sounding

-- TODO:
-- comments
-- syntax and values
-- ghci - interactive development
-- calling functions
-- function definition
-- type declarations
-- base types
-- if
-- operators
-- holes

-- show HLS features:

-- warnings
fun1 :: Int -> Int
fun1 x = 10 + 3

-- hint
fun2 :: Int -> Int
fun2 x = succ x

-- type inference and hover
fun3 :: Bool -> Char -> Char
fun3 b c =
  if b
    then c
    else 'a'

-- add type signature
fun4 x c y =
  fun3 (fun2 (fun1 x) == y) c

-- evaluate code in >>>

-- >>> 5 + 15 + 100

-- TODO: show
-- if-then-else (is an expression)
-- numeric operations
-- function application

-- Explain undefined vs _
-- Explain "taking arguments" (via c style sigs)
-- >>> fact 5
-- 120
-- >>> fact 7
-- 5040

fact :: Integer -> Integer
fact = undefined

-- 3 + 4 * 7

-- isBiggerThan add42 3 5

-- EXAMPLES
-- >>> fib 0
-- 0
--
-- >>> fib 4
-- 3
--
-- >>> fib 80
-- 21

fib :: Integer -> Integer
fib = undefined

-- use the following "mathematical definition" to implement addition on natural numbers:
-- myPlus x y = { y                        | x == 0    }
--              { succ(myPlus(pred(x), y)) | otherwise }
-- Note that succ and pred are functions that already exist
-- succ x = x + 1
-- pred x = x - 1

-- EXAMPLES
-- >>> myPlus 50 19
-- 69
--
-- >>> myPlus 0 42
-- 42

myPlus :: Integer -> Integer -> Integer
myPlus = undefined

-- same as above, implement multiplication on natural numbers recursively, using addition instead of succ
-- EXAMPLES
-- >>> myMult 3 23
-- 69
--
-- >>> myMult 0 42
-- 0
--
-- >>> myMult 1 42
-- 42
myMult :: Integer -> Integer -> Integer
myMult = undefined

-- Implement "fast exponentiation".
-- This uses the following property:
--
-- In the case of the exponent(n) being even
-- x^(2*n) == (x*x)^n
--
-- In case it's not, you can proceed as normally when doing exponentiation.
-- This is "fast" in the sense that it takes ~log(n) operations instead of ~n operations, where n is the exponent.
-- EXAMPLES
-- >>> fastPow 3 4
-- 81
-- >>> fastPow 2 6
-- 64
fastPow :: Integer -> Integer -> Integer
fastPow = undefined

-- Define two mutually recursive functions which check whether a number is even or odd.
-- Assume that the input is non-negative.
--
-- EXAMPLES
-- >>> isOdd 3
-- True
--
-- >>> isOdd 4
-- False
--
-- >>> isEven 5
-- False
--
-- >>> isEven 6
-- True

isEven :: Integer -> Bool
isEven = undefined

isOdd :: Integer -> Bool
isOdd = undefined

-- Define a function to check whether a given Integer is a prime number.
-- Assume that the input is non-negative.
-- You might need to define some "helper" functions here. You should try to do so using the where construct, which is used to define "local functions/bindings" as follows:
--
-- Instead of defining new functions at the top level which you'll only use once in isPrime, for example:
--
-- divides :: Integer -> Integer -> Bool
-- divides x y == <check if x divides y>
--
-- anyDividesInRange :: Integer -> Integer -> Bool
-- anyDividesInRange a b == <check if in the range (a,b), any of the numbers divide n. You can do this by "iterating" via recursion>
--
--
-- You can define them locally for isPrime, in which case only isPrime will be able to see and call them, like so:
--
-- `where` reminder!
-- isPrime n = ...
--   where
--     myHelperValue :: Integer
--     myHelperValue = n * 10
--
--     theHelperOfMe = myHelperValue * 10
--
--     myOtherHelper :: Integer -> Integer
--     myOtherHelper x = x + n
--
-- Note that the `n` variable bound in the isPrime declaration is visible over the entire body of the where statement.
-- As you can see, the helper bindings in the where block **must** be indented (and they must all be at the same indentation level)
--
-- In order to complete this task, you can use the rem function:
--   rem x y == what's the remainder of x when divided by y
--
-- >>> rem 10 3
-- 1
-- >>> rem 10 7
-- 3
-- >>> rem 16 7
-- 2
--
-- EXAMPLES
-- >>> isPrime 5
-- True
-- >>> isPrime 6
-- False
-- >>> isPrime 13
-- True

isPrime :: Integer -> Bool
isPrime = undefined

-- vim: foldmethod=marker:

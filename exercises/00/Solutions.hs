-- {{{ Pragmas

-- NOTE: read up more here - https://wiki.haskell.org/Language_Pragmas

-- cover all cases! # OPTIONS_GHC -fwarn-incomplete-patterns #-}
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

-- Explain undefined vs _
-- Explain "taking arguments" (via c style sigs?)
-- >>> fact 5
-- 120
-- >>> fact 7
-- 5040

fact :: Integer -> Integer
fact n =
  if n == 0
    then 1
    else n * fact (n - 1)

-- EXAMPLES
-- >>> fib 0
-- 1
-- >>> fib 4
-- 5
-- >>> fib 8
-- 34

fib :: Integer -> Integer
fib 0 = 1
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)

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
myPlus x y =
  if x == 0
    then y
    else succ (myPlus (pred x) y)

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
myMult n m =
  if n == 0
    then 0
    else myPlus m (myMult (n - 1) m)

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
fastPow x n =
  if n == 0
    then 1
    else
      if even n
        then fastPow (x * x) (n `div` 2)
        else x * fastPow x (n - 1)

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
isEven n =
  (n == 0) || ((n /= 1) && isOdd (n - 1))

-- or the easier to understand
-- isEven n =
--   if n == 0
--     then True
--     else
--       if n == 1
--         then False
--         else isOdd (n - 1)

isOdd :: Integer -> Bool
isOdd n =
  (n == 1) || ((n /= 0) && isEven (n - 1))

-- or the easier to understand
-- isOdd n =
--   if n == 0
--     then False
--     else
--       if n == 1
--         then True
--         else isEven (n - 1)

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
isPrime n = not (anyDividesInRange 2 (n - 1))
  where
    divides x y = y `rem` x == 0
    anyDividesInRange a b =
      (a <= b) && ((a `divides` n) || anyDividesInRange (succ a) b)

-- or the easier to understand
-- anyDividesInRange a b =
--   if a > b
--   then False
--   else
--    if a `divides` n
--    then True
--    else anyDividesInRange (succ a) b

-- vim: foldmethod=marker:

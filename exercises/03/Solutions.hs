{-# LANGUAGE LambdaCase #-}
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

{-# HLINT ignore "Unused LANGUAGE pragma" #-}
{-# HLINT ignore "Use foldr" #-}
{-# HLINT ignore "Use map" #-}

module ListMaybe where

import Prelude hiding (all, and, concat, drop, filter, length, map, null, product, replicate, reverse, subtract, sum, take, zip, zipWith, (++))

sumList :: [Integer] -> Integer
sumList [] = 0
sumList (x : xs) = x + sumList xs

-- >>> sumList [1,2,3]
-- 6

replicate :: Integer -> a -> [a]
replicate n x
  | n <= 0 = []
  | otherwise = x : replicate (n - 1) x

-- >>> replicate 10 5
-- [5,5,5,5,5,5,5,5,5,5]

safeDiv :: Integer -> Integer -> Maybe Integer
safeDiv _ 0 = Nothing
safeDiv x y = Just $ x `div` y

headMaybe :: [a] -> Maybe a
headMaybe [] = Nothing
headMaybe (x : _) = Just x

-- TASK:
-- Generate all the numbers in the ("mathematical range") [n, m] in a list (inclusive).

-- >>> listFromRange 3 12
-- [3,4,5,6,7,8,9,10,11,12]
-- >>> listFromRange 8 6
-- []

listFromRange :: Integer -> Integer -> [Integer]
listFromRange n m
  | n > m = []
  | otherwise = n : listFromRange (n + 1) m

-- TASK:
-- Multiply all the elements of a list

-- >>> product [2,4,8]
-- 64
-- >>> product []
-- 1

product :: [Integer] -> Integer
product [] = 1
product (x : xs) = x * product xs

-- TASK:
-- Implement factorial with prod and listFromRange

fact :: Integer -> Integer
fact n = product (listFromRange 1 n)

-- TASK:
-- Return a list of the numbers that divide the given number.

-- >>> divisors 5
-- [1,5]
-- >>> divisors 64
-- [1,2,4,8,16,32,64]
-- >>> divisors 24
-- [1,2,3,4,6,8,12,24]

divisors :: Integer -> [Integer]
divisors n = go 1
  where
    go k
      | k > n = []
      | n `mod` k == 0 = k : go (k + 1)
      | otherwise = go (k + 1)

-- TASK:
-- Implement prime number checking using listFromRange and divisors

-- >>> isPrime 7
-- True
-- >>> isPrime 8
-- False

isPrime :: Integer -> Bool
isPrime n = n > 1 && divisors n == [1, n]

-- TASK:
-- Get the last element in a list.

-- >>> lastMaybe []
-- Nothing
-- >>> lastMaybe [1,2,3]
-- Just 3

lastMaybe :: [a] -> Maybe a
lastMaybe [] = Nothing
lastMaybe [x] = Just x
lastMaybe (_ : xs) = lastMaybe xs

-- TASK:
-- Calculate the length of a list.

-- >>> length [1,2,8]
-- 3
-- >>> length []
-- 0

length :: [a] -> Integer
length [] = 0
length (_ : xs) = 1 + length xs

-- TASK:
-- Return the nth element from a list (we count from 0).
-- If n >= length xs, return a Nothing

-- >>> ix 2 [1,42,69]
-- Just 69
-- >>> ix 3 [1,42,69]
-- Nothing

ix :: Integer -> [a] -> Maybe a
ix n _ | n < 0 = Nothing
ix _ [] = Nothing
ix 0 (x : _) = Just x
ix n (_ : xs) = ix (n - 1) xs

-- TASK:
-- "Drop" the first n elements of a list.
-- If n > length xs, then you should drop them all.

-- >>> drop 5 $ listFromRange 1 10
-- [6,7,8,9,10]
-- >>> drop 20 $ listFromRange 1 10
-- []

drop :: Integer -> [a] -> [a]
drop n xs | n <= 0 = xs
drop _ [] = []
drop n (_ : xs) = drop (n - 1) xs

-- TASK:
-- "Take" the first n elements of a list.
-- If n > length xs, then you should take as many as you can.

-- >>> take 5 $ listFromRange 1 10
-- [1,2,3,4,5]
-- >>> take 20 $ listFromRange 1 10
-- [1,2,3,4,5,6,7,8,9,10]

take :: Integer -> [a] -> [a]
take n _ | n <= 0 = []
take _ [] = []
take n (x : xs) = x : take (n - 1) xs

-- TASK:
-- Append one list to another. append [1,2,3] [4,5,6] == [1,2,3,4,5,6]
-- This is called (++) in the base library.
-- HINT: Of course, you can think in the classic "inductive" way - I've got the result - what do I need to do at this step.
-- Or alternatively, you can think about "placing the second list at the end of the first":
-- 0. how do you get to the end of the first one?
-- 1. what do you need to do at each step to "remember" the elements of the first one?

-- >>> append [1,2,3] [4,5,6]
-- [1,2,3,4,5,6]
-- >>> append [] [4,5,6]
-- [4,5,6]

append :: [a] -> [a] -> [a]
append [] ys = ys
append (x : xs) ys = x : append xs ys

-- TASK:
-- Concatenate all the lists together.

-- >>> concat [[1,2,3], [42,69], [5,7,8,9]]
-- [1,2,3,42,69,5,7,8,9]
-- >>> concat [[1,2,3], [], [5,7,8,9]]
-- [1,2,3,5,7,8,9]
-- >>> concat []
-- []

concat :: [[a]] -> [a]
concat [] = []
concat (xs : xss) = append xs (concat xss)

-- TASK:
-- Reverse a list. It's fine to do this however you like.

-- >>> reverse [1,2,3]
-- [3,2,1]
-- >>> reverse []
-- []

reverse :: [a] -> [a]
reverse [] = []
reverse (x : xs) = append (reverse xs) [x]

-- TASK:
-- Square all the numbers in a list.

-- >>> squareList [1,2,3,5]
-- [1,4,9,25]

squareList :: [Integer] -> [Integer]
squareList [] = []
squareList (x : xs) = (x * x) : squareList xs

-- TASK:
-- Pair up the given element with each of the elements a list.

-- >>> megaPair 42 [69,7,42]
-- [(42,69),(42,7),(42,42)]

megaPair :: a -> [b] -> [(a, b)]
megaPair _ [] = []
megaPair a (b : bs) = (a, b) : megaPair a bs

-- TASK:
-- Both of those functions above have the same structure - apply a function to each element of a list.
-- We can abstract this and get one of the most useful functions over lists (and containers in general).

-- >>> map succ [1,2,3]
-- [2,3,4]
-- >>> map (\x -> x * x) [1,2,3] -- same as squareList
-- [1,4,9]
-- >>> map (\x -> (3,x)) [1,2,3] -- same as megaPair 3
-- [(3,1),(3,2),(3,3)]

map :: (a -> b) -> [a] -> [b]
map _ [] = []
map f (x : xs) = f x : map f xs

-- TASK:
-- Check if all the elements in a list are True.

-- >>> and []
-- True
-- >>> and [False]
-- False
-- >>> and [True, True]
-- True

and :: [Bool] -> Bool
and [] = True
and (x : xs) = x && and xs

-- TASK:
-- Check if all the elements of a list satisfy a predicate
-- Implement this using map and and.

-- >>> all isPrime [2,3,7]
-- True
-- >>> all isPrime [1,2,3,7]
-- False

all :: (a -> Bool) -> [a] -> Bool
all p xs = and (map p xs)

-- TASK:
-- Implement the cartesian product of two lists.
-- Don't use a list comprehension!

-- >>> cartesian [1,2,3] [4,5,6]
-- [(1,4),(1,5),(1,6),(2,4),(2,5),(2,6),(3,4),(3,5),(3,6)]
-- >>> cartesian [] [4,5,6]
-- []
-- >>> cartesian [1,2,3] []
-- []

cartesian :: [a] -> [b] -> [(a, b)]
cartesian [] _ = []
cartesian (x : xs) ys = append (megaPair x ys) (cartesian xs ys)

-- TASK:
-- We can generalise cartesian to work with arbitrary functions instead of just (,),
-- taking elements "each with each"
-- This is also the generalisation of cartesian, as seen in the examples.

-- >>> lift2List (+) [1] [2]
-- [3]
-- >>> lift2List (+) [1,2] [2]
-- [3,4]
-- >>> lift2List (*) [1,2,3] [1,2]
-- [1,2,2,4,3,6]
-- >>> lift2List (,) [1,2,3] [4,5,6] -- same as cartesian [1,2,3] [4,5,6]
-- [(1,4),(1,5),(1,6),(2,4),(2,5),(2,6),(3,4),(3,5),(3,6)]

lift2List :: (a -> b -> c) -> [a] -> [b] -> [c]
lift2List _ [] _ = []
lift2List f (x : xs) ys = append (map (f x) ys) (lift2List f xs ys)

-- TASK:
-- The "filtering" part of a list comprehension - leave only those elements, that satisfy the given predicate.

-- >>> even 2
-- True
-- >>> even 3
-- False
-- >>> filter even [1..10]
-- [2,4,6,8,10]
-- >>> filter isPrime [1..20]
-- [2,3,5,7,11,13,17,19]

filter :: (a -> Bool) -> [a] -> [a]
filter _ [] = []
filter p (x : xs)
  | p x = x : filter p xs
  | otherwise = filter p xs

data Digit
  = Zero
  | One
  | Two
  | Three
  | Four
  | Five
  | Six
  | Seven
  | Eight
  | Nine
  deriving (Show, Enum)

-- TASK:
-- Parse a character into a digit.
-- The easiest way is to pattern match on all the cases.
--
-- OPTIONAL: You can try to use the LambdaCase extension here, in order to avoid writing parseDigit 10 times:
-- First, you need to add {-# LANGUAGE LambdaCase #-} to the top of the file (it's already enabled in this file)
-- Second, lambda case is used as follows:
-- Every time you write `\case ...`, that is desugared into `\x -> case x of ...`
-- For example:
-- safeDiv n = \case
--   0 -> Nothing
--   m -> ...
--

-- >>> parseDigit '6'
-- Just Six
-- >>> parseDigit '9'
-- Just Nine
-- >>> parseDigit 'c'
-- Nothing

parseDigit :: Char -> Maybe Digit
parseDigit = \case
  '0' -> Just Zero
  '1' -> Just One
  '2' -> Just Two
  '3' -> Just Three
  '4' -> Just Four
  '5' -> Just Five
  '6' -> Just Six
  '7' -> Just Seven
  '8' -> Just Eight
  '9' -> Just Nine
  _ -> Nothing

-- TASK:
-- See if all the values in a list xs are Just, returning Just xs only if they are.
-- We can think of this as all the computations in a list "succeeding",
-- and therefore the entire "computation list" has "succeeded.
-- Note that it is vacuously that all the elements in the empty list are Just.

-- >>> validateList []
-- Just []
-- >>> validateList [Just 42, Just 6, Just 9]
-- Just [42,6,9]
-- >>> validateList [Nothing, Just 6, Just 9]
-- Nothing
-- >>> validateList [Just 42, Nothing, Just 9]
-- Nothing
-- >>> validateList [Just 42, Just 6, Nothing]
-- Nothing

validateList :: [Maybe a] -> Maybe [a]
validateList [] = Just []
validateList (mx : mxs) =
  case mx of
    Nothing -> Nothing
    Just x ->
      case validateList mxs of
        Nothing -> Nothing
        Just xs -> Just (x : xs)

-- TASK:
-- You often have a collection (list) of things, for each of which you want to
-- perform some computation, that might fail (returning Maybe).
-- Let's implement a function to do exactly this -
-- execute a "failing computation" for all the items in a list,
-- immediately "aborting" upon a failure.
-- Think about how to reuse validateList.
-- This is called traverseListMaybe, because it's a special case of a generic function called traverse
-- that performs "actions" for each element of a "collection", specialised to List and Maybe

-- >>> traverseListMaybe (\x -> if even x then Just x else Nothing) [2,4,6]
-- Just [2,4,6]
-- >>> traverseListMaybe (\x -> if even x then Just x else Nothing) [1,2,3]
-- Nothing
-- >>> traverseListMaybe (5 `safeDiv`) [0,2]
-- Nothing
-- >>> traverseListMaybe (8 `safeDiv`) [3,2]
-- Just [2,4]

traverseListMaybe :: (a -> Maybe b) -> [a] -> Maybe [b]
traverseListMaybe f xs = validateList (map f xs)

-- TASK:
-- Convert a list of digits to a number.
-- You can use `toEnum :: Digit -> Int` to convert digit into an `Int`
-- and `fromIntegral :: Int -> Integer` to convert an `Int` into an `Integer`
-- Assume that the empty list converts to 0.
-- HINT: It might be easier to first reverse the list and then operate on it with a helper.

-- >>> digitsToNumber [Six,Nine]
-- 69
-- >>> digitsToNumber [One,Two,Zero]
-- 120
-- >>> digitsToNumber [Zero,One,Two,Zero]
-- 120

digitsToNumber :: [Digit] -> Integer
digitsToNumber = go 0
  where
    -- for some reason, we often call helpers in haskell "go", as in "go do the thing"
    go acc [] = acc
    go acc (d : ds) = go (acc * 10 + fromIntegral (fromEnum d)) ds

-- TASK:
-- Combine the previous functions to parse a number.

-- >>> parseNumber "0"
-- Just 0
-- >>> parseNumber "3"
-- Just 3
-- >>> parseNumber "69"
-- Just 69
-- >>> parseNumber "0123"
-- Just 123
-- >>> parseNumber "blabla"
-- Nothing
-- >>> parseNumber "133t"
-- Nothing

parseNumber :: String -> Maybe Integer
parseNumber s =
  case traverseListMaybe parseDigit s of
    Nothing -> Nothing
    Just ds -> Just (digitsToNumber ds)

-- parseNumber s = maybeMap digitsToNumber (traverseListMaybe parseDigit s)

-- TASK:
-- Notice how in parseNumber, in the Nothing case we returned Nothing,
-- and in the Just case, we returned Just again, with a "non-maybe" function inside.
-- This turns out to be very useful, and if you compare it to the map for lists, it's almost the same.
-- Let's write it now, so we don't have to do that pattern match again in the future.
-- Afterwards, you can reuse this function in parseNumber.

-- >>> maybeMap succ $ Just 5
-- Just 6
-- >>> maybeMap succ Nothing
-- Nothing

maybeMap :: (a -> b) -> Maybe a -> Maybe b
maybeMap _ Nothing = Nothing
maybeMap f (Just x) = Just (f x)

-- TASK:
-- Another way to combine lists
-- Instead of "taking all possible combinations" we group the lists "pointwise"
-- If one list is shorter than the other, you can stop there.

-- >>> zip [1,2,3] [4,5,6]
-- [(1,4),(2,5),(3,6)]
-- >>> zip [1,2] []
-- []
-- >>> zip [1] [4,5,6]
-- [(1,4)]

zip :: [a] -> [b] -> [(a, b)]
zip [] _ = []
zip _ [] = []
zip (x : xs) (y : ys) = (x, y) : zip xs ys

-- TASK:
-- And the generalised version of zip.

-- >>> zipWith (,) [1,2,3] [4,5]
-- [(1,4),(2,5)]
-- >>> zipWith (+) [1,2,3] [4,5,6]
-- [5,7,9]
-- >>> zipWith (:) [1,2,3] [[4],[5,7],[]]
-- [[1,4],[2,5,7],[3]]

zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith _ [] _ = []
zipWith _ _ [] = []
zipWith f (x : xs) (y : ys) = f x y : zipWith f xs ys

-- TASK:
-- Transpose a matrix. Assume all the inner lists have the same length.
-- HINT: zipWith and map might be useful here.

-- >>> transpose [[1]]
-- [[1]]
-- >>> transpose [[1,2,3],[4,5,6],[7,8,9]]
-- [[1,4,7],[2,5,8],[3,6,9]]
-- >>> transpose [[1],[2]]
-- [[1,2]]
-- >>> transpose [[1,2,3],[4,5,6]]
-- [[1,4],[2,5],[3,6]]

transpose :: [[a]] -> [[a]]
-- Usually deemed invalid, but just in case...
transpose [] = []
-- Actual base-case: single-row matrix turning into a single-column one
transpose [xs] = map (: []) xs
-- Try picturing what this'd do in your head
-- - first, what the recusion actually computes
-- - second, what we do on top of that to achieve our result
transpose (xs : xss) = zipWith (:) xs (transpose xss)

-- TASK:
-- Reverse a list, but in linear time (so if the input list has n elements, you should only be doing at most ~n operations, not n^2)
-- You will need a helper local definition.

-- >>> reverse [1,2,3]
-- [3,2,1]
-- >>> reverse []
-- []

reverseLinear :: [a] -> [a]
reverseLinear = go []
  where
    -- NOTE: Turn the "stuff we do after the recursion"
    --       into a separate argument, whose initial value
    --       is the classic "recursion base" value
    go acc [] = acc
    go acc (y : ys) = go (y : acc) ys

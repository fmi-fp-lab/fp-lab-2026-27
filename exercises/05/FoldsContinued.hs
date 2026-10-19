-- vim: set fdm=marker:

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

{-# HLINT ignore "Use foldl" #-}
{-# HLINT ignore "Use foldr" #-}
{-# HLINT ignore "Use map" #-}

module FoldsContinued where

import Prelude hiding (foldl, foldr, reverse)

-- TODO:
-- remind about the homework deadline and the second homework
-- tail recursion (it is the same as a while loop)
-- foldl as the "linear" version of foldr, draw both on the board
-- Either (Maybe is to null what Either is to exceptions)
-- folds as destructors, mirrored to constructors, again (drive the point home)

-- NOTE: from the previous exercise, repeated so that this file works on its own
-- the base case comes first, just like in {foldNat}

foldr :: b -> (a -> b -> b) -> [a] -> b
foldr orig _ [] = orig
foldr orig f (x : xs) = x `f` rest
  where
    rest = foldr orig f xs

-- >>> foldr 0 (+) [1..5]
-- 15

-- NOTE: foldl is the "linear" version of foldr - it carries one accumulator,
-- instead of building the result on the way back out of the recursion

foldl :: (b -> a -> b) -> b -> [a] -> b
foldl _ acc [] = acc
foldl f acc (x : xs) = foldl f (acc `f` x) xs

-- >>> foldl (\acc x -> acc - x) 0 [1,2,3]
-- -6

reverseFoldl :: [a] -> [a]
reverseFoldl = foldl (flip (:)) []

-- >>> reverseFoldl [1,2,3]
-- [3,2,1]

safeDiv :: Integer -> Integer -> Maybe Integer
safeDiv _ 0 = Nothing
safeDiv n m = Just $ n `div` m

-- data Maybe a = Nothing | Just a
-- data Either a b = Left a | Right b

-- NOTE: The {DZero} has a D because Nat also has a constructor called {Zero}
data Digit
  = DZero
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
-- Every time you write {\case ...}, that is desugared into {\x -> case x of ...}
-- For example:
-- safeDiv n = \case
--   0 -> Nothing
--   m -> ...

-- >>> parseDigit '6'
-- Just Six
-- >>> parseDigit '9'
-- Just Nine
-- >>> parseDigit 'c'
-- Nothing

parseDigit :: Char -> Maybe Digit
parseDigit = undefined

-- TASK:
-- See if all the values in a list xs are Just, returning Just xs only if they are.
-- We can think of this as all the computations in a list "succeeding",
-- and therefore the entire "computation list" has "succeeded".
-- HINT: you can write this with foldr, but you have to be careful with the
-- order in which the {Nothing}s travel outwards.

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
validateList = undefined

-- TASK:
-- You often have a collection (list) of things, for each of which you want to
-- perform some computation, that might fail (returning Maybe).
-- Let's implement a function to do exactly this -
-- execute a "failing computation" for all the items in a list,
-- immediately "aborting" upon a failure.
-- Think about how to reuse validateList.
-- This is called traverseListMaybe, because it's a special case of a generic function called traverse

-- >>> traverseListMaybe (\x -> if even x then Just x else Nothing) [2,4,6]
-- Just [2,4,6]
-- >>> traverseListMaybe (\x -> if even x then Just x else Nothing) [1,2,3]
-- Nothing
-- >>> traverseListMaybe (5 `safeDiv`) [0,2]
-- Nothing
-- >>> traverseListMaybe (8 `safeDiv`) [3,2]
-- Just [2,4]

traverseListMaybe :: (a -> Maybe b) -> [a] -> Maybe [b]
traverseListMaybe = undefined

-- TASK:
-- Convert a list of digits to a number.
--
-- You can use {fromEnum :: Digit -> Int} to convert digit into an {Int}
-- and {fromIntegral :: Int -> Integer} to convert an {Int} into an {Integer}
--
-- Assume that the empty list converts to 0.

-- >>> digitsToNumber [Six,Nine]
-- 69
-- >>> digitsToNumber [One,Two,DZero]
-- 120
-- >>> digitsToNumber [DZero,One,Two,DZero]
-- 120

digitsToNumber :: [Digit] -> Integer
digitsToNumber = undefined
  where
    -- for some reason, we often call helpers in haskell "go", as in "go do the thing"
    go = undefined

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
parseNumber = undefined

-- TASK:
-- Notice how in parseNumber, in the Nothing case we returned Nothing,
-- and in the Just case, we returned Just again, with a "non-maybe" function inside.
-- This turns out to be very useful, and if you compare it to the {map} for lists, it's almost the same.
-- Let's write it now, so we don't have to do that pattern match again in the future.

-- >>> maybeMap succ $ Just 5
-- Just 6
-- >>> maybeMap succ Nothing
-- Nothing

maybeMap :: (a -> b) -> Maybe a -> Maybe b
maybeMap = undefined

-- TASK:
-- Reverse a list using foldl.
-- It might help to implement the "accumulating with a helper" version first, if you haven't already.
-- What's the complexity of your reverse, compared to {reverseFoldl}?

-- >>> reverse [1,2,3]
-- [3,2,1]
-- >>> reverse []
-- []

reverse :: [a] -> [a]
reverse = undefined

-- TASK:
-- A smaller version of one of the tasks from a FP exam.
-- We have instructions for a "stack machine" - so something that keeps a stack for memory (so a list)
-- Push n is meant to push the value n on the stack
-- Map f is meant to apply f to *all* of the items in the stack in place, so without removing them
-- Oper f is meant to pop the top two items from the stack, apply f to them, and push the result back on the stack

data Instruction
  = Push Integer
  | Map (Integer -> Integer)
  | Oper (Integer -> Integer -> Integer)

-- TASK:
-- Implement the interpreter for our stack machine, given a list of instructions.
-- You can use a helper for the "recursion" at first, if you want to, but implement the "recursive part" using foldl afterwards.
-- We return the final state of the stack.
-- Note the {Maybe}, because we can't be sure that {Oper} will always succeed, because we might not have two arguments in our stack.
-- We'll consider this failure a critical error, and won't attempt to recover from a failure.

-- >>> runMachine [Push 9, Push 6]
-- Just [6,9]
-- >>> runMachine [Oper (+)]
-- Nothing
-- >>> runMachine [Push 42, Oper (+)]
-- Nothing
-- >>> runMachine [Push 42, Push 69, Oper (+)]
-- Just [111]
-- >>> runMachine [Push 42, Oper (+), Push 69]
-- Nothing
-- >>> runMachine [Push 7, Push 2, Map (\x -> x * x), Push 5]
-- Just [5,4,49]
-- >>> runMachine [Push 7, Push 2, Map (\x -> x * x), Push 5, Oper (*), Oper (+)]
-- Just [69]
-- >>> runMachine [Push 7, Push 2, Oper (+), Oper (+)]
-- Nothing

runMachine :: [Instruction] -> Maybe [Integer]
runMachine = undefined
  where
    -- Given the current stack machine state, execute an instruction.
    runInstruction :: Maybe [Integer] -> Instruction -> Maybe [Integer]
    runInstruction = undefined

-- TASK:
-- Look at the recursor for {Nat}s - {foldNat}. In there we replaced {Nat}'s constructors with "things".
-- Think about how a fold for tuples should look like, and implement it.
-- Does this function remind you of another function we've previously implemented?

-- foldTuple :: ?
-- foldTuple = undefined

-- TASK:
-- Same as above, but this time for Maybe

-- foldMaybe :: ?
-- foldMaybe = undefined

-- TASK:
-- Same as above, but this time for Either
-- Reminder: Either is defined like so:
-- data Either a b = Left a | Right b

-- foldEither :: ?
-- foldEither = undefined

-- TASK:
-- A (binary) tree is either empty, or it has an element (a root) along with a left and right subtree

data Tree a
  = Empty
  | Node (Tree a) a (Tree a)
  deriving (Show)

-- TASK:
-- A function to construct leaves (trees whose left and right subtree are Empty) more easily.

leaf :: a -> Tree a
leaf x = Node Empty x Empty

-- TASK:
-- The depth of a tree is the length of the longest path from the root to an {Empty}.
-- An {Empty} tree has depth 0.

-- >>> depth Empty
-- 0
-- >>> depth $ leaf 5
-- 1
-- >>> depth (Node (leaf 5) 6 Empty)
-- 2
-- >>> depth (Node (leaf 5) 6 (Node (leaf 7) 8 Empty))
-- 3

depth :: Tree a -> Integer
depth = undefined

-- TASK:
-- Reverse a tree, so that every left subtree becomes a right subtree.

-- >>> reverseTree $ leaf 5
-- Node Empty 5 Empty
-- >>> reverseTree $ Node (leaf 5) 6 (leaf 7)
-- Node (Node Empty 7 Empty) 6 (Node Empty 5 Empty)

reverseTree :: Tree a -> Tree a
reverseTree = undefined

-- TASK:
-- Think about what a "fold" for a Tree would be and implement it.
-- Remember - you need to look at the constructors.
-- The tree fold takes two things: what an {Empty} becomes, and how to combine
-- the folded left subtree, the root, and the folded right subtree.
-- Note how this is {foldNat} again, just with one more recursive position.

-- foldTree :: ???
-- foldTree = undefined

-- TASK:
-- Find the depth of a tree using foldTree

-- >>> depth' Empty
-- 0
-- >>> depth' $ leaf 5
-- 1
-- >>> depth' (Node (leaf 5) 6 Empty)
-- 2
-- >>> depth' (Node (leaf 5) 6 (Node (leaf 7) 8 Empty))
-- 3

depth' :: Tree a -> Integer
depth' = undefined

-- TASK:
-- Reverse a tree using foldTree

-- >>> reverseTree' $ leaf 5
-- Node Empty 5 Empty
-- >>> reverseTree' $ Node (leaf 5) 6 (leaf 7)
-- Node (Node Empty 7 Empty) 6 (Node Empty 5 Empty)

reverseTree' :: Tree a -> Tree a
reverseTree' = undefined

-- TASK:
-- Map over a tree using foldTree

-- >>> mapTree succ $ leaf 5
-- Node Empty 6 Empty
-- >>> mapTree (\x -> x * x) $ Node (leaf 5) 6 (leaf 7)
-- Node (Node Empty 25 Empty) 36 (Node Empty 49 Empty)

mapTree :: (a -> b) -> Tree a -> Tree b
mapTree = undefined

-- TASK:
-- Insert into a binary search tree, keeping the "ordered" property.
-- BST definition:
-- Empty is a BST
-- Node l x r is a BST if
-- * l is a BST
-- * r is a BST
-- * x is larger than all of the elements in l
-- * x is smaller than all of the elements in r

-- >>> insert 5 Empty
-- Node Empty 5 Empty
-- >>> insert 5 $ leaf 6
-- Node (Node Empty 5 Empty) 6 Empty
-- >>> insert 5 $ leaf 4
-- Node Empty 4 (Node Empty 5 Empty)
-- >>> insert 5 $ (Node (leaf 4) 7 (leaf 8))
-- Node (Node Empty 4 (Node Empty 5 Empty)) 7 (Node Empty 8 Empty)

insert :: Integer -> Tree Integer -> Tree Integer
insert = undefined

-- TASK:
-- Use foldr to convert a list into a BST.
-- Remember that our foldr takes the base case first.

-- >>> listToTree [2,1,3]
-- Node (Node Empty 1 (Node Empty 2 Empty)) 3 Empty
-- >>> listToTree [1,2,3]
-- Node (Node (Node Empty 1 Empty) 2 Empty) 3 Empty
-- >>> listToTree [4,1,2,5]
-- Node (Node (Node Empty 1 Empty) 2 (Node Empty 4 Empty)) 5 Empty

listToTree :: [Integer] -> Tree Integer
listToTree = undefined

-- TASK:
-- Use foldTree to convert a tree into a list. You should be walking the tree in a "left root right" order.

-- >>> treeToList $ leaf 5
-- [5]
-- >>> treeToList $ (Node (leaf 6) 5 (leaf 3))
-- [6,5,3]
-- >>> treeToList $ (Node (Node (leaf 7) 8 (leaf 69)) 5 (leaf 3))
-- [7,8,69,5,3]

treeToList :: Tree a -> [a]
treeToList = undefined

-- TASK:
-- Sort a list using the above two functions.
-- Do the operations that this sort executes remind you of some other sorting technique?

-- >>> sort [4,2,1,3]
-- [1,2,3,4]

sort :: [Integer] -> [Integer]
sort = undefined

-- TASK:
-- Use foldTree to check if an element is in a tree, assuming it's a BST.

-- >>> searchTree 5 $ listToTree [1,2,3]
-- False
-- >>> searchTree 2 $ listToTree [1,2,3]
-- True

searchTree :: Integer -> Tree Integer -> Bool
searchTree = undefined

-- TASK:
-- Use foldTree to delete all the occurences of an element from a tree.
-- In the case that the root "disappears", it's fine to merge the left tree into the right one (or vice versa).
-- I chose merging the left tree into the right one, so the examples might not be exactly the same for you.

-- >>> deleteTree 5 $ listToTree [5,5,5]
-- Empty
-- >>> deleteTree 5 $ listToTree [1,5,5,8,6]
-- Node (Node Empty 1 Empty) 6 (Node Empty 8 Empty)
-- >>> deleteTree 5 $ listToTree [1,5,67,5,8]
-- Node (Node Empty 1 Empty) 8 (Node Empty 67 Empty)

deleteTree :: Integer -> Tree Integer -> Tree Integer
deleteTree = undefined

-- TASK:
-- Trees also admit "a foldr"
-- Is there more than one way to write a foldr for trees? What's the difference?
-- Keep the same argument order as our list {foldr}: base case first.

foldrTree :: b -> (a -> b -> b) -> Tree a -> b
foldrTree = undefined

-- TASK:
-- Sum a tree using foldrTree

-- >>> sumTree $ listToTree [1,2,3]
-- 6

sumTree :: Tree Integer -> Integer
sumTree = undefined

-- TASK:
-- Convert a tree into a list using foldrTree

-- >>> treeToList' $ (Node (leaf 6) 5 (leaf 3))
-- [6,5,3]

treeToList' :: Tree a -> [a]
treeToList' = undefined

data Nat
  = Zero
  | Succ Nat
  deriving (Show)

-- TASK:
-- If Nats can be converted to "n times applications" via foldNat,
-- is it perhaps true that "n times applications" can also be converted to Nats somehow?
--
-- You can ignore this "forall explanation" bit below if you want to - just assume the forall means "the passed function must be polymorphic over a"
-- {{{ "forall explanation"
-- Usually when we have a polymorphic function, like id :: a -> a
-- the *caller* chooses what a will be - when the caller writes {id 'a'}, they instantiate {a} with {Char}, so {id} becomes {id :: Char -> Char}
-- However, here we will need our function to work for any {a}, and so we must *require* something of the caller -
-- that they provide a function working *for any* {a} - meaning *we*(the callee) can decide what {a} to apply it for, reversing who can pick what the type is.
--
-- As a concrete example, consider
-- ```
-- f :: (a -> a) -> Bool
-- f g = g True
-- ```
-- this does *not* compile - let's assume it did:
-- If we have
-- ```
-- h :: Int -> Int
-- h x = x + 1
-- ```
-- then the caller would be able to write {f h}, (as they pick what {a} is) which is not valid,
-- since {h} requires its argument and return types to be {Int}, and {True :: Bool}, which is not {Int}
-- If we instead consider
-- ```
-- f :: (forall a. a -> a) -> Bool
-- f g = g True
-- ```
-- we, as implementors of {f}, are now allowed to pick what {a} to use, hence we are allowed to pick {a ~ Bool},
-- by calling {g} with {True :: Bool}
-- Hence, this function now compiles, and furthermore, if our hypothetical caller now attempts to do
-- {f h}
-- They will get a compilation error, since the argument to {f} needs to work *for any* type, while {h} has the concrete type {Int -> Int}
-- }}} "forall explanation"

-- >>> iterateToNat (\f x -> f (f (f x)))
-- Succ (Succ (Succ Zero))

iterateToNat :: (forall a. (a -> a) -> a -> a) -> Nat
iterateToNat _f = undefined

-- TASK:
-- This is the same as foldNat, except with arguments reaarranged to mirror {iterateToNat}

natToIterate :: Nat -> (a -> a) -> a -> a
natToIterate = undefined

-- TASK:
-- Hey, if we can convert between Natural (the type argument to {iterateToNat}, now with a synonym) and {Nat} without losing information
-- wouldn't that mean that they are equivalent, and we can do the same things with both?
-- Let's reimplement some of the operations over {Nat} with {Natural} instead:

type Natural = forall a. (a -> a) -> a -> a

-- These are called "church encoded" natural numbers - they're used to represent natural numbers when the only thing you have is functions.
--
-- Here's some exposition:
-- As you saw in the {iterateToNat} example, these Naturals are essentially applying some function to some value a number of times.
-- The idea is that we represent the number {n} as applying a function {f} {n} times to a value {v}.
-- For example:
-- 0 is represented by \f v -> v

zero :: Natural
zero _f v = v

-- 1 is represented by \f v -> f v
-- 2 is represented by \f v -> f (f v)
-- 3 is represented by \f v -> f (f (f v))
-- and so on
-- With this function, we need to somehow "add another f".

-- >>> iterateToNat zero
-- Zero
-- >>> iterateToNat $ suc $ suc zero
-- Succ (Succ Zero)

suc :: Natural -> Natural
suc _n = undefined

-- TASK:
-- We can also add these. Here we need to think about how to add f n times to another Natural.

-- >>> iterateToNat $ add (suc (suc zero)) zero
-- Succ (Succ Zero)
-- >>> iterateToNat $ add (suc (suc zero)) (suc (suc (suc zero)))
-- Succ (Succ (Succ (Succ (Succ Zero))))

add :: Natural -> Natural -> Natural
add _n _m = undefined

-- TASK:
-- Now multiply them

-- >>> iterateToNat $ mult (suc (suc zero)) zero
-- Zero
-- >>> iterateToNat $ mult zero (suc (suc zero))
-- Zero
-- >>> iterateToNat $ mult (suc (suc zero)) (suc (suc zero))
-- Succ (Succ (Succ (Succ Zero)))

mult :: Natural -> Natural -> Natural
mult _n _m = undefined

-- Is the same true for lists? Is there some function type that is "isomorphic" to lists - you can convert
-- back and forth between lists and the function, without losing data? Like how Natural is to Nat
-- (or if you prefer - can you express lists by only using lambdas?)

-- TASK:
-- foldr is more general than foldl. Indeed, we can even implement foldl using foldr
-- HINT: We're going to be constructing a function, which we then apply to our initial value v.
-- We want the function to emulate what foldl f v xs would normally do.
-- id and (.) are going to be useful.
-- It might also help to think about, if f' = flip f, how you can transform
-- f' x (f' y v))
-- into
-- f (f v x) y
-- Use type holes - if you write _ in a place where you want an argument, you'll get an error explaining what the type
-- that's expected there is.

foldlViaFoldr :: forall a b. (b -> a -> b) -> b -> [a] -> b
foldlViaFoldr = undefined

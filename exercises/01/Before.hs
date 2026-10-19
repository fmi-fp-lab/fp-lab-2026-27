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

module ADTs where

-- TODO: talk about
-- - join + write on discord
-- - solutions (linked in discord)
-- - first homework this week
-- - `TODO` -> stuff for me
--   `TASK` -> stuff for you
-- TODO: show
-- - pragmas on the top of files
-- - `undefined` vs `error` vs `_`
-- - "taking arguments" (via `C`-style signatures)
-- - operators and sections
-- - `case` and pattern matching
-- - guards
-- - mention `deriving (Show)`

----------------------------------------------
-- RPS (Rock, Paper, Scissors) and Booleans --
----------------------------------------------

data RPS = Rock | Paper | Scissors
  deriving (Show)

-- TASK:
-- Define which RPS value beats another.
-- Use pattern matching and `_` where appropriate.

-- >>> beats Rock Paper
-- False
-- >>> beats Paper Rock
-- True

beats :: RPS -> RPS -> Bool
beats = undefined

-- TASK:
-- Define the next throw in the usual ordering of RPS.

-- >>> next Rock
-- Paper

next :: RPS -> RPS
next = undefined

-- TASK:
-- Define equality for RPS values.
-- Use pattern matching and `_` where appropriate.

-- >>> eqRPS Rock Rock
-- True
-- >>> eqRPS Rock Paper
-- False

eqRPS :: RPS -> RPS -> Bool
eqRPS = undefined

-- TASK:
-- Define a shorter version of `beats` using `next` and `eqRPS`.

-- >>> beats' Rock Paper
-- True
-- >>> beats' Paper Scissors
-- True

beats' :: RPS -> RPS -> Bool
beats' = undefined

----------------------------------------
-- Natural Numbers (Peano Arithmetic) --
----------------------------------------

data Nat = Zero | Succ Nat
  deriving (Show)

-- TASK:
-- Convert an Integer to Nat.

-- >>> integerToNat 3
-- Succ (Succ (Succ Zero))

integerToNat :: Integer -> Nat
integerToNat = undefined

-- TASK:
-- Convert a Nat back to an Integer.

-- >>> natToInteger (Succ (Succ Zero))
-- 2

natToInteger :: Nat -> Integer
natToInteger = undefined

-- TASK:
-- Add two Nats.

-- >>> addNat (Succ Zero) (Succ Zero)
-- Succ (Succ Zero)

addNat :: Nat -> Nat -> Nat
addNat = undefined

-- TASK:
-- Multiply two Nats.

-- >>> multNat (Succ (Succ Zero)) (Succ (Succ (Succ Zero)))
-- Succ (Succ (Succ (Succ (Succ (Succ Zero)))))

multNat :: Nat -> Nat -> Nat
multNat = undefined

-- TASK:
-- Compare two Nats, returning an Ordering.

-- >>> compareNat (Succ Zero) Zero
-- GT

compareNat :: Nat -> Nat -> Ordering
compareNat = undefined

-- TASK:
-- Return the maximum of two Nats.

-- >>> maxNat (Succ Zero) (Succ (Succ Zero))
-- Succ (Succ Zero)

maxNat :: Nat -> Nat -> Nat
maxNat = undefined

-----------------
-- Expressions --
-----------------

data Expr
  = Val Integer
  | Plus Expr Expr
  | Mult Expr Expr
  deriving (Show)

infixr 7 `Plus`
infixr 8 `Mult`

-- TASK:
-- Evaluate an expression in the Expr language.

-- >>> eval (Val 3)
-- 3
-- >>> eval (Plus (Val 3) (Val 4))
-- 7
-- >>> eval (Mult (Val 3) (Val 4))
-- 12

eval :: Expr -> Integer
eval = undefined

-- TASK:
-- Extend the Expr language with If expressions.
-- Interpret 0 as false and any non-zero value as true.

------------
-- Belote --
------------

data Rank = A
  deriving (Show)

data Suit = B
  deriving (Show)

-- TASK:
-- Check if two suits are equal.

suitEquals :: Suit -> Suit -> Bool
suitEquals = undefined

-- TODO: define the Card record syntax.
data Card = MkCard {rank :: Rank, suit :: Suit}
  deriving (Show)

data Contract
  deriving (Show)

-- TASK:
-- Check if a card has a trump suit for a given contract.

isTrump :: Contract -> Card -> Bool
isTrump = undefined

-- TASK:
-- Assign a numerical power value to a card for a contract.
-- Higher values represent stronger cards.

cardPower :: Contract -> Card -> Integer
cardPower = undefined

-- TASK:
-- Define the four ways two cards can relate under a contract.

data CardRelation
  deriving (Show)

-- TASK:
-- Calculate how two cards relate under a contract.

relateCards :: Contract -> Card -> Card -> CardRelation
relateCards = undefined

-- TASK:
-- Return the winning card. Assume the first card was played first.

fight :: Contract -> Card -> Card -> Card
fight = undefined

-- TASK:
-- Define a Trick containing four cards.

data Trick
  deriving (Show)

-- TASK:
-- Determine the winning card in a Trick.
-- The leftmost card was played first.

winner :: Contract -> Trick -> Card
winner = undefined

-- TASK:
-- Check whether a Trick could have been played under the rules of Belote.

isValid :: Contract -> Trick -> Bool
isValid = undefined

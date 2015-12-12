#!/usr/bin/env runhaskell
-- TheoremBlock.hs
-- Automatically creates Theorem and Proof envirnoments from text

import Text.Pandoc.JSON

checkParagraph :: [Inline]-> Block
checkParagraph (Strong x:rest)
  | x == [Str("Teoremă.")]  = Div ("mylabel", ["theorem"], []) [Para rest]
  | otherwise       = Para (Strong x:rest)
checkParagraph rest = Para rest

makeTheorem :: Block -> Block
makeTheorem (Para x)  = checkParagraph x
makeTheorem x = x

main :: IO ()
main = toJSONFilter makeTheorem




#!/usr/bin/env runhaskell
-- TheoremBlock.hs
-- Automatically creates Theorem and Proof envirnoments from strong text
-- Momentarily, just filters *Teorema* from the beginning of a paragraph

import Text.Pandoc.JSON

checkParagraph :: [Inline] -> Block
checkParagraph (Strong x:rest)
  | x == [Str("Teoremă.")]  = Div ("mylabel", ["theorem"], []) [Para rest]  --Str("HeiSalut") : rest
  | otherwise       = Para (Strong x:rest)
checkParagraph rest = Para rest

makeTheorem :: Block -> Block
makeTheorem (Para x)  = checkParagraph x
makeTheorem x = x

main :: IO ()
main = toJSONFilter makeTheorem


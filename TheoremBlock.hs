#!/usr/bin/env runhaskell
-- TheoremBlock.hs
-- Automatically creates Theorem and Proof envirnoments from strong text
-- Momentarily, just filters *Teorema* from the beginning of a paragraph

import Text.Pandoc.JSON

checkParagraph :: [Inline] -> [Inline]
checkParagraph (Strong x:rest) = rest
checkParagraph rest = rest

makeTheorem :: Block -> Block
makeTheorem (Para x)  = Para (checkParagraph x)
makeTheorem x = x

main :: IO ()
main = toJSONFilter makeTheorem


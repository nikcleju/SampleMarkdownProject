#!/usr/bin/env runhaskell
-- WriteTheoremBlock.hs
-- Writes Theorem and Proof envirnoments to latex or html

import Text.Pandoc.JSON

writeTheorem :: Maybe Format -> Int -> Block -> [Block]
writeTheorem (Just format) number (Div (label, classes, otherlist) contents)
  | format == Format "latex" 
       = latex "\\begin{theorem}" : contents ++ [latex "\\end{theorem}"]
  | format == Format "html"
       = html ("<dt>Teorema " ++ show number ++ "</dt>") : html "<dd>" : contents ++ [html "</dd>\n</dl>"]
  where latex = RawBlock (Format "latex")  -- function: RawBlock format String
        html  = RawBlock (Format "html")   -- function: RawBlock format String
writeTheorem _ _ x = [x]

--idea: go through all Pandoc Blocks, apply series of functions with n as parameters
writeTheoremsWithCnt :: Maybe Format -> Pandoc -> Pandoc
writeTheoremsWithCnt format (Pandoc meta blocks) = Pandoc meta (processBlocks format [1..] blocks)

processBlocks :: Maybe Format -> [Int] -> [Block] -> [Block]
-- empty list of blocks
processBlocks _ _ [] = []
-- first element is Div -> check if theorem and process it
processBlocks format numbers (x@(Div (label, classes, otherlist) contents):xs)
  | "theorem" `elem` classes 
    = ((writeTheorem format (head numbers) x) ++ processBlocks format (tail numbers) xs)
-- else -> process rest of list, don't advance numbers list
processBlocks format numbers (x:xs) = x : processBlocks format numbers xs

main :: IO ()
--main = toJSONFilter writeTheorem
main = toJSONFilter writeTheoremsWithCnt

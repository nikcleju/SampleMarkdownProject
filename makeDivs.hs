#!/usr/bin/env runhaskell
-- WriteTheoremBlock.hs
-- Writes Theorem and Proof envirnoments to latex or html

import Text.Pandoc.JSON


makeDivs :: Maybe Format -> Pandoc -> Pandoc
makeDivs format (Pandoc meta blocks) = Pandoc meta (writeDivBlocks format 1 $ convertToDivBlocks blocks)
--makeDivs format (Pandoc meta blocks) = Pandoc meta (convertToDivBlocks blocks)


convertToDivBlocks :: [Block] -> [Block]
convertToDivBlocks blocks = foldr foldSingleBlock [] blocks


foldSingleBlock :: Block -> [Block] -> [Block]
-- if current element is a Para with start and end, add Div
foldSingleBlock para@(Para paracontents) acc
  | head paracontents == Strong [Str "Teoremă."] && last paracontents == Strong [Str "End."]
    = (Div ("mylabel", ["theorem"], []) [Para $ tail . init $ paracontents]) : acc
-- if current element is a Para and last element in acc is a Div
foldSingleBlock para@(Para paracontents) acc@((Div (label, classes, attr) divcontents):acctail)
      -- if last Div is ongoing and "Teorema." encountered, add to Div, add theorem class and stop making it ongoing
  | ("ongoing", "yes") `elem` attr  && head paracontents == Strong [Str "Teoremă."]
    = (Div (label, "theorem":classes, []) ((Para $ tail paracontents) :divcontents)) : acctail
      -- if last Div is ongoing, add to Div, keep ongoing
  | ("ongoing", "yes") `elem` attr
    = (Div (label, classes, attr) (para:divcontents)) : acctail
-- if last element in acc is not Div and "End." encountered, create new Div ongoing
foldSingleBlock para@(Para paracontents) acc
  | last paracontents == Strong [Str "End."]
    = (Div ("mylabel", [], [("ongoing", "yes")]) [Para $ init paracontents]) : acc
-- if current element is not a Para and last element in acc is a Div
foldSingleBlock block acc@((Div (label, classes, attr) divcontents):acctail)
      -- if last Div is ongoing, add to Div, keep ongoing
  | ("ongoing", "yes") `elem` attr
    = (Div (label, classes, attr) (block:divcontents)) : acctail
-- if last element in acc is not a Div, add to acc
foldSingleBlock block acc  = block : acc


writeDivBlocks :: Maybe Format -> Int -> [Block] -> [Block]
-- if first block in list is a Div, try to convert and recurse
writeDivBlocks format number (divblock@(Div (label, classes, attr) divcontents):restblocks)
  | "theorem" `elem` classes  = (writeTheoremBlock format number divcontents) ++ (writeDivBlocks format (number+1) restblocks)
-- else just recurse
writeDivBlocks format number (x:xs) = x : writeDivBlocks format number xs
writeDivBlocks _ _ [] = []


writeTheoremBlock :: Maybe Format -> Int -> [Block] -> [Block]
writeTheoremBlock (Just format) number divcontents
  | format == Format "latex" 
       = latex "\\begin{theorem}" : divcontents ++ [latex "\\end{theorem}"]
  | format == Format "html"
       = html ("<dt>Teorema " ++ show number ++ "</dt>") : html "<dd>" : divcontents ++ [html "</dd>\n</dl>"]
  | otherwise  = divcontents
   where latex = RawBlock (Format "latex")  -- function: RawBlock format String 
         html  = RawBlock (Format "html")   -- function: RawBlock format String


main :: IO ()
main = toJSONFilter makeDivs


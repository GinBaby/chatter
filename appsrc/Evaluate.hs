{-# LANGUAGE OverloadedStrings #-}
module Evaluate where

import qualified Data.ByteString as BS
import Data.Serialize (decode)
import qualified Data.Text as T
import qualified Data.Text.IO as T

import System.Environment (getArgs)

import NLP.Corpora.Parsing
import NLP.POS (eval, loadTagger)
import NLP.POS.AvgPerceptronTagger (mkTagger)

main :: IO ()
main = do
  args <- getArgs
  let modelFile = args!!0
      corpora = tail args
  putStrLn "Loading model..."
  tagger <- loadTagger modelFile
  putStrLn "...model loaded."
  rawCorpus <- mapM T.readFile corpora
  let taggedCorpora = (map readPOS $ concatMap T.lines $ rawCorpus)
      result = eval tagger taggedCorpora
  putStrLn ("Result: " ++ show result)

--  T.putStrLn $ tagText tagger (T.pack sentence)
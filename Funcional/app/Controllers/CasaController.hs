{-# LANGUAGE OverloadedStrings #-}

module Controllers.CasaController where

import Data.Aeson
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as BC
import Data.Maybe
import Models.Casa
import Models.Quiz
import System.Directory
import System.IO
import System.IO.Unsafe

instance FromJSON Casa

instance FromJSON Quiz

getCasasJSON :: [Casa]
getCasasJSON = do
  let file = unsafePerformIO (B.readFile "./database/casas.json")
  let decodedFile = decode file :: Maybe [Casa]
  fromMaybe [] decodedFile

getCasaByID :: Int -> [Casa] -> Casa
getCasaByID _ [] = Casa (-1) "" "" [] []
getCasaByID idS (x : xs)
  | idCasa x == idS = x
  | otherwise = getCasaByID idS xs

getQuizByID :: Int -> [Quiz] -> Quiz
getQuizByID _ [] = Quiz (-1) "" "" "" "" "" ""
getQuizByID idS (x : xs)
  | idQuiz x == idS = x
  | otherwise = getQuizByID idS xs

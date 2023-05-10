{-# LANGUAGE DeriveGeneric #-}

module Models.Quiz where

import GHC.Generics (Generic)

data Quiz = Quiz
  { idQuiz :: Int,
    pergunta :: String,
    a :: String,
    b :: String,
    c :: String,
    d :: String,
    resposta :: String
  }
  deriving (Show, Generic)

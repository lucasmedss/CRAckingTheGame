{-# LANGUAGE DeriveGeneric #-}

module Models.Nota where

import GHC.Generics (Generic)

data Nota = Nota
  { jogador :: String,
    cra :: Double,
    numeroDisciplinas :: Int
  }
  deriving (Show, Generic)

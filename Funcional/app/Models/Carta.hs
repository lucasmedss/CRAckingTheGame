{-# LANGUAGE DeriveGeneric #-}

module Models.Carta where

import GHC.Generics (Generic)

data Carta = Carta
  { tipo :: String,
    nome :: String,
    descricao :: String
  }
  deriving (Show, Generic)

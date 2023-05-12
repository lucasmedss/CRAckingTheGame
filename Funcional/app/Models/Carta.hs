{-# LANGUAGE DeriveGeneric #-}

module Models.Carta where

import GHC.Generics (Generic)

data Carta = Carta
  { tipo :: String,
    idCarta :: Int,
    nomeC :: String,
    descricaoC :: String
  }
  deriving (Show, Generic)

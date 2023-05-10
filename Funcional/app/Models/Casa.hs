{-# LANGUAGE DeriveGeneric #-}

module Models.Casa where

import GHC.Generics (Generic)
import Models.Quiz (Quiz)

data Casa = Casa
  { idCasa :: Int,
    nome :: String,
    descricao :: String,
    requisitos :: [String],
    quiz :: [Quiz]
  }
  deriving (Show, Generic)

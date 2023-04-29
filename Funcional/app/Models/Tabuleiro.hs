module Models.Tabuleiro where

import Models.Casa (Casa)
import Models.Jogador (Jogador)

data Tabuleiro = Tabuleiro
  { casas :: [Casa],
    jogadores :: [Jogador]
  }
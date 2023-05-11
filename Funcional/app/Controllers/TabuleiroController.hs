module Controllers.TabuleiroController where

import Data.List (intercalate, isInfixOf, isPrefixOf)
import System.Console.ANSI
import System.IO
import System.IO.Unsafe (unsafePerformIO)
import Text.Printf (printf)

getTabuleiro :: [String]
{-# NOINLINE getTabuleiro #-}
getTabuleiro = do
  let tabuleiro = unsafePerformIO (readFile "./database/tabuleiro.txt")
  lines tabuleiro

exibirTabuleiro :: [String] -> IO ()
exibirTabuleiro tabuleiro = do
  putStrLn (unlines tabuleiro)

getLinha :: [String] -> String -> Int -> Int
getLinha [] _ _ = -1
getLinha (x : xs) casa index
  | casa `isInfixOf` x = index
  | otherwise = getLinha xs casa (index + 1)

getColuna :: String -> String -> Int
getColuna linha casa
  | casa `isPrefixOf` linha = 0
  | otherwise = case getColuna (drop 1 linha) casa of
      index
        | index /= -1 -> index + 1
        | otherwise -> -1

getPosicao :: [String] -> String -> (Int, Int)
getPosicao tabuleiro casa = do
  let linha = getLinha tabuleiro casa 0
  let coluna = getColuna (tabuleiro !! linha) casa
  (linha, coluna)

modificarTabuleiro :: [String] -> String -> String -> [String]
modificarTabuleiro tabuleiro jogador proximaPosicao = do
  let atual = getPosicao tabuleiro jogador
  let linhaTabuleiro = tabuleiro !! fst atual
  let novaLinha = replaceChar (snd atual) " " linhaTabuleiro
  let novoTabuleiro = intercalate "\n" (take (fst atual) tabuleiro ++ [novaLinha] ++ drop (fst atual + 1) tabuleiro)

  let proximoAtual = getPosicao (lines novoTabuleiro) (printf "%02s" proximaPosicao)
  let posicaoJogador = if jogador == "X" then snd proximoAtual + 1 else snd proximoAtual

  let proximaLinhaTabuleiro = lines novoTabuleiro !! (fst proximoAtual - 1)
  let proximaNovaLinha = replaceChar posicaoJogador jogador proximaLinhaTabuleiro
  let proximoNovoTabuleiro = intercalate "\n" (take (fst proximoAtual - 1) (lines novoTabuleiro) ++ [proximaNovaLinha] ++ drop (fst proximoAtual) (lines novoTabuleiro))
  return proximoNovoTabuleiro

replaceChar :: Int -> String -> String -> String
replaceChar i c s = take i s ++ c ++ drop (i + 1) s

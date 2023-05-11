module Main where

import Controllers.CasaController (getCasaByID, getCasasJSON, getQuizByID)
import Controllers.JogoController (iniciaJogo)
import Controllers.TabuleiroController (exibirTabuleiro, getTabuleiro, modificarTabuleiro)
import GHC.IO.Handle (hClose)
import System.Console.ANSI
import System.IO
import System.Random

main :: IO ()
main = do
  menu getTabuleiro

menu :: [String] -> IO ()
menu tabuleiro = do
  clearScreen
  setCursorPosition 0 0
  putStrLn "Seja bem-vindo ao CRAcking the Game!"
  arquivo <- openFile "./database/menu.txt" ReadMode
  conteudo <- hGetContents arquivo
  putStrLn conteudo
  hClose arquivo
  opcao <- getLine
  case opcao of
    "1" -> do
      putStrLn "Jogar"
      iniciaJogo 1
    "2" -> do
      putStrLn "Jogar contra o Bot"
      iniciaJogo 2
    "3" -> do
      putStrLn "Obrigado por jogar CRAcking the Game\nAté mais!"
      return ()
    _ -> do
      putStrLn "Opção inválida"
      menu tabuleiro

jogar :: [String] -> Int -> IO ()
jogar tabuleiro atual = do
  dado <- randomRIO (1, 6 :: Int)
  exibirTabuleiro tabuleiro
  let novaPosicao = atual + dado
  if novaPosicao >= 33
    then do
      let novoTabuleiro = modificarTabuleiro tabuleiro "Y" "CC"
      exibirTabuleiro novoTabuleiro
      putStrLn "Você chegou ao final do tabuleiro! Parabéns!\nPressione ENTER para voltar para o menu principal."
      esperar <- getLine
      main
    else do
      let novoTabuleiro = modificarTabuleiro tabuleiro "Y" (show novaPosicao)
      putStrLn ("Você tirou: " ++ show dado ++ "\nPressione ENTER para continuar")
      esperar <- getLine
      jogar novoTabuleiro novaPosicao

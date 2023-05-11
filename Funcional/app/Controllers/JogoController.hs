{-# LANGUAGE BlockArguments #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use print" #-}

module Controllers.JogoController where

import Controllers.CasaController (getCasaByID, getCasasJSON, getQuizByID)
import Controllers.TabuleiroController (exibirTabuleiro, getTabuleiro, modificarTabuleiro)
import Data.Int (Int)
import Models.Casa
import Models.Casa (Casa (requisitos))
import Models.Quiz
import System.Console.ANSI
import System.Random

iniciaJogo :: Int -> IO ()
iniciaJogo 1 = singlePlayer 0 getTabuleiro []
iniciaJogo 2 = multiplayer 0 0 1 getTabuleiro []

multiplayer :: Int -> Int -> Int -> [String] -> [String] -> IO ()
multiplayer 33 _ _ _ _ = putStrLn "aeeee acabou o jogo"
multiplayer 0 0 1 tabuleiro requisitos = do
  limpaTela
  putStrLn "Seja bem-vindo ao CRAcking the Game!\nVamos começar!\n"
  exibirTabuleiro tabuleiro
  putStrLn "Pressione ENTER para rolar o dado"
  esperar <- getLine
  dado <- rodaDado
  putStrLn ("Você tirou " ++ show dado ++ " no dado!\nPressione ENTER para continuar")
  esperar <- getLine
  limpaTela
  let novoTabuleiro = modificarTabuleiro tabuleiro "X" (show dado)
  exibirTabuleiro novoTabuleiro
  let casa = getCasaByID dado getCasasJSON
  resultado <- interacao novoTabuleiro casa requisitos
  if resultado
    then do
      putStrLn "Parabéns por ter acertado! Agora é a vez do Bot. Pressione ENTER e aguarde sua vez!"
      esperar <- getLine
      multiplayer dado 0 2 novoTabuleiro requisitos
  else do
    putStrLn "Que pena, você errou! Passou a vez para o bot jogar."
    let tabuleiroAtualizado = modificarTabuleiro tabuleiro "X" (show (dado - 1))
    exibirTabuleiro tabuleiroAtualizado
    voltaCasaMultiplayer (dado - 1) 0 2 tabuleiroAtualizado requisitos
multiplayer x y 1 tabuleiro requisitos = do
  limpaTela
  let casa = getCasaByID x getCasasJSON
  let requisitosCasa = Models.Casa.requisitos casa
  let todasAsDisciplinasCursadas = all (`elem` requisitos) requisitosCasa
  if todasAsDisciplinasCursadas
    then do
      resultado <- interacao tabuleiro casa requisitos
      if resultado
        then do
          putStrLn "Parabéns por ter obtido sucesso!\nPressione ENTER para rolar o dado."
          -- acertouCRA
          esperar <- getLine
          limpaTela
          exibirTabuleiro tabuleiro
          dado <- rodaDado
          putStrLn ("Você tirou " ++ show dado ++ " no dado!\nPressione ENTER para continuar.")
          esperar <- getLine
          let novoTabuleiro = modificarTabuleiro tabuleiro "X" (show (dado + x))
          exibirTabuleiro novoTabuleiro
          putStrLn "Agora é a vez do Bot. Pressione ENTER e aguarde sua vez!"
          esperar <- getLine
          multiplayer (x + dado) y 2 novoTabuleiro (requisitos ++ [nome casa])
        else do
          putStrLn "aaaawwww errou, vai voltar uma casa!"
          voltaCasaMultiplayer (x - 1) y 2 tabuleiro requisitos
    else do
      putStrLn "Você não tem os requisitos para essa casa, vai voltar uma casa!"

      voltaCasaMultiplayer (x - 1) y 2 tabuleiro (requisitos ++ requisitosCasa)
multiplayer x y 2 tabuleiro requisitos = do
  interacaoBot x y 1 tabuleiro requisitos

interacaoBot :: Int -> Int -> Int -> [String] -> [String] -> IO ()
interacaoBot x y jogador tabuleiro requisitos = do
  --randomNumber <- randomRIO (0, 2 :: Int)
  let randomNumber = 0 
  if randomNumber == 0
    then do
      dado <- rodaDado
      putStrLn ("O bot acertou a resposta e avançou " ++ show dado ++ " casas\nPessione ENTER para continuar.")
      esperar <- getLine
      let novaPosicao = dado + y
      let novoTabuleiro = modificarTabuleiro tabuleiro "Y" (show novaPosicao)
      exibirTabuleiro novoTabuleiro
      multiplayer x novaPosicao 1 novoTabuleiro requisitos
    else do
      putStrLn "O bot errou e voltou uma casa"
      -- let novaPosicao = if y > 1 then y - 1 else y
      let novoTabuleiro = modificarTabuleiro tabuleiro "Y" (show (y - 1))
      multiplayer x (y - 1) 1 novoTabuleiro requisitos

voltaCasaMultiplayer :: Int -> Int -> Int -> [String] -> [String] -> IO ()
voltaCasaMultiplayer x y jogador tabuleiro requisitos = do
  putStrLn "Voltou uma casa e agora quem joga é o bot"
  input <- getLine
  let novoTabuleiro = modificarTabuleiro tabuleiro "X" (show x)
  multiplayer x y 2 novoTabuleiro requisitos

singlePlayer :: Int -> [String] -> [String] -> IO ()
singlePlayer 0 tabuleiro requisitos = do
  limpaTela
  putStrLn "Seja bem-vindo ao CRAcking the Game!\nVamos começar!\n"
  exibirTabuleiro tabuleiro
  putStrLn "Pressione ENTER para rolar o dado."
  esperar <- getLine
  dado <- rodaDado
  putStrLn ("Você tirou " ++ show dado ++ " no dado!\nPressione ENTER para avançar!")
  esperar <- getLine
  let novoTabuleiro = modificarTabuleiro tabuleiro "X" (show dado)
  singlePlayer dado novoTabuleiro requisitos
singlePlayer x tabuleiro requisitos = do
  limpaTela
  let casa = getCasaByID x getCasasJSON
  let requisitosCasa = Models.Casa.requisitos casa
  let todasAsDisciplinasCursadas = all (`elem` requisitos) requisitosCasa
  if todasAsDisciplinasCursadas
    then do
      resultado <- interacao tabuleiro casa requisitos
      if resultado
        then do
          putStrLn "Parabéns por ter obtido sucesso!\nPressione ENTER para rolar o dado."
          -- acertouCRA
          esperar <- getLine
          limpaTela
          exibirTabuleiro tabuleiro
          dado <- rodaDado
          let novaPosicao = x + dado
          putStrLn ("Você tirou " ++ show dado ++ " no dado!\nPressione ENTER para avançar!")
          esperar <- getLine
          let novoTabuleiro = modificarTabuleiro tabuleiro "X" (show novaPosicao)
          exibirTabuleiro novoTabuleiro
          singlePlayer novaPosicao novoTabuleiro (requisitos ++ [nome casa])
        else do
          putStrLn "aaaawwww errou, vai voltar uma casa!"
          voltaCasa (x - 1) tabuleiro requisitos
    else do
      exibirTabuleiro tabuleiro
      putStrLn "Você não tem as disciplinas necessárias para avançar nessa casa!\nPressione ENTER para voltar uma casa."
      esperar <- getLine
      voltaCasa (x - 1) tabuleiro (requisitos ++ requisitosCasa)
  if x >= 33
    then do
      let novoTabuleiro = modificarTabuleiro tabuleiro "X" "CC"
      exibirTabuleiro novoTabuleiro
      putStrLn "Você chegou ao final do tabuleiro! Parabéns!\nPressione ENTER para voltar para o menu principal."
      esperar <- getLine
      return ()
    else do
      limpaTela
      let casa = getCasaByID x getCasasJSON
      let requisitosCasa = Models.Casa.requisitos casa
      let todasAsDisciplinasCursadas = all (`elem` requisitos) requisitosCasa
      if todasAsDisciplinasCursadas
        then do
          resultado <- interacao tabuleiro casa requisitos
          if resultado
            then do
              putStrLn "Parabéns por ter obtido sucesso!\nPressione ENTER para rolar o dado."
              -- acertouCRA
              esperar <- getLine
              dado <- rodaDado
              let novaPosicao = x + dado
              putStrLn ("Você tirou " ++ show dado ++ " no dado!\nPressione ENTER para avançar!")
              esperar <- getLine
              let novoTabuleiro = modificarTabuleiro tabuleiro "X" (show novaPosicao)
              singlePlayer novaPosicao novoTabuleiro (requisitos ++ [nome casa])
            else do
              putStrLn "aaaawwww errou, vai voltar uma casa!"
              voltaCasa (x - 1) tabuleiro requisitos
        else do
          exibirTabuleiro tabuleiro
          putStrLn "Você não tem as disciplinas necessárias para avançar nessa casa!\nPressione ENTER para voltar uma casa."
          esperar <- getLine
          voltaCasa (x - 1) tabuleiro (requisitos ++ requisitosCasa)

-- errouCRA
-- voltaCasa (x - 1)

interacao :: [String] -> Casa -> [String] -> IO Bool
interacao tabuleiro casa requisitos = do
  putStrLn (show (descricao casa))
  exibirTabuleiro tabuleiro
  let quizCasa = quiz casa
  if null quizCasa
    then do
      putStrLn "Não tem quiz"
      return True
    else do
      executaQuiz quizCasa

-- requisitos <- Json.getRequisitos (x)
-- disciplinasCursada <- Json.historico . getDisciplinasCursadas ()
-- Comparação entre array de disciplinas com array de requisitos, if False then return false

executaQuiz :: [Quiz] -> IO Bool
executaQuiz quiz = do
  seleciona <- randomRIO (1, 3)
  let quizSelecionado = getQuizByID seleciona quiz
  putStrLn (show (pergunta quizSelecionado))
  putStrLn (show (a quizSelecionado))
  putStrLn (show (b quizSelecionado))
  putStrLn (show (c quizSelecionado))
  putStrLn (show (d quizSelecionado))
  input <- getLine
  if input == resposta quizSelecionado
    then do
      return True
    else do
      return False

limpaTela :: IO ()
limpaTela = do
  clearScreen
  setCursorPosition 0 0

-- executaCasaComplementar :: String -> Int -> IO ()
-- executaCasaComplementar tipoCarta idPlayer = do
--   if (idPlayer == 1) then do
--     if (tipoCarta == "positiva") then do
--       executaAcaoPositiva "humano"
--     else do
--       executaAcaoNegativa "humano"
--   else do
--     if (tipoCarta == "positiva") then do
--       executaAcaoPositiva "bot"
--     else do
--       executaAcaoNegativa "bot"

-- executaAcaoPositiva ::  IO ()
-- executaAcaoNegativa
--   |
--   |
-- -- Vários casamentos de padrão com o resultado do numero aleatorio.

-- executaAcaoNegativa :: IO ()
-- executaAcaoNegativa
--   |
--   |
-- -- Vários casamentos de padrão com o resultado do numero aleatorio.

voltaCasa :: Int -> [String] -> [String] -> IO ()
voltaCasa x tabuleiro requisitos = do
  let novoTabuleiroErro = modificarTabuleiro tabuleiro "X" (show x)
  limpaTela
  exibirTabuleiro novoTabuleiroErro
  putStrLn "Você voltou uma casa!\nPressione ENTER para jogar o dado novamente."
  esperar <- getLine
  dado <- rodaDado
  putStrLn ("Você tirou " ++ show dado ++ " no dado!\nPressione ENTER para avançar!")
  esperar <- getLine
  let novoTabuleiro = modificarTabuleiro novoTabuleiroErro "X" (show (x + dado))
  singlePlayer (dado + x) novoTabuleiro requisitos

rodaDado :: IO Int
rodaDado = randomRIO (1, 4)

-- -- Adicionar na BD um array com as notas adquiridas, aí usamos ela para calcular a média do CRA

-- -- Calcula a média dos CRAs (NAO SEI SE ESTA ATUALIZADO)
-- calculaCRA :: [Double] -> Double
-- calculaCRA [] = 0
-- calculaCRA xs = sum xs / length xs

-- acertouCRA :: Double
-- acertouCRA = 7.0 + (randomRIO (1, 6) * 0.5)

-- errouCRA :: Double
-- errouCRA = 5.0 - (randomRIO (1, 20) * 0.25)

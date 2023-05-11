{-# LANGUAGE BlockArguments #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use print" #-}

module Controllers.JogoController where

import Controllers.CasaController (getCasaByID, getCasasJSON, getQuizByID)
import Controllers.TabuleiroController (exibirTabuleiro, getTabuleiro, modificarTabuleiro)
import Models.Casa
import Models.Quiz
import System.Console.ANSI
import System.Random
import Models.Casa (Casa(requisitos))

iniciaJogo :: Int -> IO ()
iniciaJogo 1 = singlePlayer 0 getTabuleiro []

-- iniciaJogo 2 = multiplayer 0 1 getTabuleiro

-- multiplayer :: Int -> Int -> [String] -> IO ()
-- multiplayer 33 x tabueiro = putStrLn "aeeee acabou o jogo"
-- multiplayer 0 1 tabuleiro = do
--   putStrLn "Seja bem-vindo ao CRAcking the Game!"
--   exibirTabuleiro tabuleiro
--   putStrLn "Pressione ENTRER para rolar o dado"
--   input <- readLine
--   resultado <- rodaDado ()
--   modificarTabuleiro tabuleiro "X" resultado
--   multiplayer resultado 2
-- multiplayer x 1 tabuleiro = do
--   if interacao (x)
--     then do
--       putStrLn "Parabéns por ter acertado, digite 'roll' para ver quantas casas você vai avançar!"
--       input <- readLine
--       resultado <- rodaDado () + x
--       Json.escreveTabuleiro ("x", resultado) -- PseudoCodigo
--       Json.historico . adicionaDisciplina (x) -- PseudoCodigo
--       multiplayer (x + resultado) 2
--     else do
--       putStrLn "aaaawwww errou, vai voltar uma casa!"
--       voltaCasaMultiplayer (x - 1)
-- multiplayer x 2 tabuleiro= do
--   interacaoBot ()
--   multiplayer (x) 1

-- interacaoBot :: IO ()
-- interacaoBot = do
--   randomNumber <- randomRIO (0, 2 :: Int)
--   if randomNumber == 0
--     then do
--       resultado <- rodaDado ()
--       putStrLn "O bot acertou e avançou " ++ resultado ++ " casas"
--       Json.escreveTabuleiro ("y", y + resultado) -- PseudoCodigo
--     else
--       putStrLn
--         "O bot errou e voltou uma casa"
--         Json.escreveTabuleiro
--         ("y", y - 1) -- PseudoCodigo

-- voltaCasaMultiplayer :: Int -> IO ()
-- voltaCasaMultiplayer x = do
--   putStrLn "Voltou uma casa e agora quem joga é o bot"
--   input <- readLine
--   Json.escreveTabuleiro ("x", x) -- PseudoCodigo
--   multiplayer x 2

singlePlayer :: Int -> [String] -> [String] -> IO ()
singlePlayer 33 tabuleiro requisitos = do
  let novoTabuleiro = modificarTabuleiro tabuleiro "X" "CC"
  exibirTabuleiro novoTabuleiro
  putStrLn "Você chegou ao final do tabuleiro! Parabéns!\nPressione ENTER para voltar para o menu principal."
  esperar <- getLine
  return ()
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
  if todasAsDisciplinasCursadas then do
    resultado <- interacao tabuleiro casa requisitos
    if resultado
      then do
        putStrLn "Parabéns por ter obtido sucesso\nPressione ENTER para rolar o dado."
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

-- executaCasaComplementar :: String -> IO ()
-- executaCasaComplementar "positivo" = executaAcaoPositiva randomRIO (A, B)
-- executaCasaComplementar "negativo" = executaAcaoNegativa randomRIO (A, B)

-- executaAcaoPositiva :: IO ()
-- -- Vários casamentos de padrão com o resultado do numero aleatorio.

-- executaAcaoNegativa :: IO ()
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

-- main :: IO ()
-- main = do
--   putStrLn "Olá, seja bem vinde ao CRAcking the game bla bla bla. Pra jogar singleplayer digite '1' ou contra bot '2'"
--   input <- readLine
--   let opcao = read input :: Int
--   iniciaJogo opcao
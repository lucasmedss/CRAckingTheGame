{-# LANGUAGE ScopedTypeVariables #-}

module Controllers.CraController where
    
import Models.Nota
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Char8 as BC
import Data.Aeson
import System.Directory
import System.IO
import System.IO.Unsafe
import Data.Maybe
import System.Random

instance FromJSON Nota

instance ToJSON Nota

getNotasJSON :: [Nota]
getNotasJSON = do
    let file = unsafePerformIO (B.readFile "./database/notas.json")
    let decodedFile = decode file :: Maybe [Nota]
    fromMaybe [] decodedFile

zeraNotasJSON :: IO()
zeraNotasJSON = do
    let n1 = Nota "humano" 0.0 0
    let n2 = Nota "bot" 0.0 0
    let notasZeradas = [n1] ++ [n2]
    sobrescreverNotas notasZeradas

getCraByJogador :: String -> [Nota] -> Double
getCraByJogador player (x:xs)
    | (jogador x) == player = cra x
    | otherwise = cra (head xs)

getNumeroDisciplinasByJogador :: String -> [Nota] -> Int
getNumeroDisciplinasByJogador player (x:xs)
    | (jogador x) == player = numeroDisciplinas x
    | otherwise = numeroDisciplinas (head xs)

removeNotaByJogador :: String -> [Nota] -> [Nota]
removeNotaByJogador player (x:xs)
    | (jogador x) == player = xs
    | otherwise = [x] ++ (removeNotaByJogador player xs)

aumentaCraPorJogada :: String -> IO()
aumentaCraPorJogada player = do
    let notas = getNotasJSON
    let cra = getCraByJogador player notas
    let numeroDisciplinas = getNumeroDisciplinasByJogador player notas
    dado <- randomRIO (1 :: Int, 3 :: Int)
    let notaDado = 7.0 + fromIntegral dado
    let craAtualizado = (cra * fromIntegral numeroDisciplinas + notaDado) / fromIntegral (numeroDisciplinas + 1)
    let n = Nota player craAtualizado (numeroDisciplinas + 1)
    let notasAtualizadas = (removeNotaByJogador player notas) ++ [n]
    sobrescreverNotas notasAtualizadas

aumentaCraPorCarta :: String -> IO()
aumentaCraPorCarta player = do
    let notas = getNotasJSON
    let cra = getCraByJogador player notas
    let numeroDisciplinas = getNumeroDisciplinasByJogador player notas
    dado <- randomRIO (1 :: Int, 3 :: Int)
    let acrescimo = (fromIntegral dado) * 0.2
    if (cra + acrescimo) > 10.0 then do
        let craAtualizado = 10.0
        let n = Nota player craAtualizado (numeroDisciplinas)
        let notasAtualizadas = (removeNotaByJogador player notas) ++ [n]
        sobrescreverNotas notasAtualizadas
    else do
        let craAtualizado = cra + acrescimo
        let n = Nota player craAtualizado (numeroDisciplinas)
        let notasAtualizadas = (removeNotaByJogador player notas) ++ [n]
        sobrescreverNotas notasAtualizadas

diminuiCraPorCarta :: String -> IO()
diminuiCraPorCarta player = do
    let notas = getNotasJSON
    let cra = getCraByJogador player notas
    let numeroDisciplinas = getNumeroDisciplinasByJogador player notas
    dado <- randomRIO (1 :: Int, 3 :: Int)
    let decrescimo = (fromIntegral dado) * 0.2
    if (cra - decrescimo) < 0.0 then do
        let craAtualizado = 0.0
        let n = Nota player craAtualizado (numeroDisciplinas)
        let notasAtualizadas = (removeNotaByJogador player notas) ++ [n]
        sobrescreverNotas notasAtualizadas
    else do
        let craAtualizado = cra - decrescimo
        let n = Nota player craAtualizado (numeroDisciplinas)
        let notasAtualizadas = (removeNotaByJogador player notas) ++ [n]
        sobrescreverNotas notasAtualizadas

sobrescreverNotas :: [Nota] -> IO ()
sobrescreverNotas notas = do
    B.writeFile "./database/Temp.json" $ encode notas
    removeFile "./database/notas.json"
    renameFile "./database/Temp.json" "./database/notas.json" 
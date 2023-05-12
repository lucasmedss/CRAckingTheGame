module Controllers.DeckController where

import Data.Aeson
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as BC
import Data.Maybe
import Models.Carta
import System.Directory
import System.IO
import System.IO.Unsafe
import System.Random (mkStdGen)
import System.Random.Shuffle (shuffle')

instance FromJSON Carta

instance ToJSON Carta

getDeckJSON :: [Carta]
getDeckJSON = do
  let file = unsafePerformIO (BC.readFile "./database/deck.json")
  let decodedFile = decode file :: Maybe [Carta]
  fromMaybe [] decodedFile

getCartaById :: Int -> [Carta] -> Carta
getCartaById _ [] = Carta "" (-1) "" ""
getCartaById idS (x : xs)
  | idCarta x == idS = x
  | otherwise = getCartaById idS xs

moveCarta :: IO ()
moveCarta = do
  let deck = getDeckJSON
  let carta = head deck
  let novoDeck = tail deck ++ [carta]
  sobrescreverDeck novoDeck

compraCarta :: Carta
compraCarta = do
  let deck = getDeckJSON
  head deck

embaralharDeck :: IO ()
embaralharDeck = do
  let deck = getDeckJSON
  let deckEmbaralhadoJSON = shuffle' deck (length deck) (mkStdGen 42)
  sobrescreverDeck deckEmbaralhadoJSON

sobrescreverDeck :: [Carta] -> IO ()
sobrescreverDeck deck = do
  B.writeFile "./database/Temp.json" $ encode deck
  removeFile "./database/deck.json"
  renameFile "./database/Temp.json" "./database/deck.json"

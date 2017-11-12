{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Network.Wai.Middleware.RequestLogger

import System.Environment
import qualified Service.Registry as S

import Data.Text (Text)
import qualified Data.Text as T

import Capability

main :: IO ()
main = do

  res <- register "Capability"
  putStrLn $ T.unpack res


  scotty 3000 server
{-
    middleware logStdoutDev

    get "/health" $ do
      text "UP"

    get "/:profile" $ do
      profile <- param "profile"
      json $ getAccountBalancesForProfile profile
-}

server :: ScottyM ()
server = do
  middleware logStdoutDev

  get "/health" healthHandler
  get "/:profile" mainHandler


healthHandler :: ActionM ()
healthHandler = do
  text "UP"


mainHandler :: ActionM ()
mainHandler = do
  profile <- param "profile"
  json $ getAccountBalancesForProfile profile


register :: Text -> IO Text
register svc = do
  let e = S.endpoint "GET" "/"
  S.register svc [e]

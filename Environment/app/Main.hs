{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Network.Wai.Middleware.RequestLogger

import Control.Monad.Trans (liftIO)

import Environment

main :: IO ()
main = do

  scotty 3000 $ do
    middleware logStdoutDev

    get "/health" $ do
      text "UP"

    get "/" $ do
      env <- liftIO createEnvironment
      json env

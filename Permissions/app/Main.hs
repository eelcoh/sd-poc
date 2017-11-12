{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Network.Wai.Middleware.RequestLogger
import Control.Monad.Trans (liftIO)

import qualified Service.Registry as S
import qualified Data.Text as T
import Data.Text (Text)

import Network.HostName
import qualified Permissions

main :: IO ()
main = do

  res <- register "Permissions"
  putStrLn $ T.unpack res

  scotty 3000 $ do
    middleware logStdoutDev

    get "/health" $ do
      text "UP"

    get "/:profile" $ do
      profile <- param "profile"
      hostname <- liftIO getHostName
      json $ Permissions.get (T.pack hostname) profile

register :: Text -> IO Text
register svc = do
  let e = S.endpoint "GET" "/"
  S.register svc [e]

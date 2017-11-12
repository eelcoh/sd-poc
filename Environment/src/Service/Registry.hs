{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Service.Registry
    ( register
    , endpoint
    ) where

import GHC.Generics
import Data.Aeson
import Data.Either
import Data.Text (Text)
import qualified Data.Text as T
import Service.Types
import Data.Monoid ((<>))
import Utils.Elmify ((|>))
import Utils.Bytes (byteStringToString)

import Network.HTTP
import Network.HostName
import System.Environment

type ServiceName = Text

register :: ServiceName -> [Endpoint] -> IO Text
register svc es = do
  serviceDiscovery <- getEnv "SERVICE_DISCOVERY_SERVICE_HOST"
  let portName =  "MY_POD_IP"
  ip <- getEnv (T.unpack portName)
  hostname' <- getHostName
  let url = createRegisterUrl serviceDiscovery (T.unpack svc) hostname'
  register' url hostname' ip es


register' :: String -> String -> String -> [Endpoint] -> IO Text
register' url hostname' ip' es =
  let

    svc =
      Service {
          endpoints = es
        , hostname = (T.pack hostname')
        , ip = (T.pack ip')
        , version = "0.0.1"
        }

    req = postRequestWithBody mime url (byteStringToString jsonStr)

    mime = "application/json"

    jsonStr = encode svc

    resp =
      simpleHTTP req
        >>= getResponseCode

  in

    fmap responseResult resp

createRegisterUrl :: String -> String -> String -> String
createRegisterUrl base svc inst =
  "http://" ++ base ++ "/service/" ++ svc ++ "/instance/" ++ inst

endpoint :: Text -> Text -> Endpoint
endpoint method path =
  Endpoint method path

responseResult :: ResponseCode -> Text
responseResult res =
  let

    resToString (a, b, c) =
      fmap show [a,b,c]
      |> fmap T.pack
      |> T.concat

    responseCodeAsText =
      resToString res

  in
    case res of
      (2, _, _) ->
         ("Ok " <> responseCodeAsText)
      _ ->
         ("Err " <> responseCodeAsText)

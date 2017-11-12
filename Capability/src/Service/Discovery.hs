{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Service.Discovery
    ( discover
    ) where

import GHC.Generics
import Data.Aeson
import Data.Either
import Data.Text (Text)
import qualified Data.Text as T
import Data.Monoid ((<>))
import Utils.Elmify ((|>))
import Network.HTTP
import Utils.Bytes (byteStringToString)
import Control.Monad.Trans (liftIO)
import System.Environment

type Service = Text
type Method = Text
type Path = Text

discover :: Service -> Method -> Path -> IO String
discover service method path = do
    serviceDiscovery <- getEnv "SERVICE_DISCOVERY_SERVICE_HOST"

    let url = serviceDiscovery ++ "/service/" ++ (T.unpack service)
    let req = getRequest url

    rsp <- simpleHTTP req
    getResponseBody rsp
    --body <- getResponseBody rsp

    --fmap decode body


data Endpoint = Endpoint {
      inst :: Text
    , hostname :: Text
    , ip :: Text
    , service :: Text
    , method :: Text
    , path :: Text
    } deriving ( Show)

instance FromJSON Endpoint where
  parseJSON (Object x) = Endpoint <$> x .: "instance" <*> x.: "host" <*> x .: "ip" <*> x .: "service" <*> x .: "method" <*> x .: "path"
  parseJSON _ = fail "Expected an Object"

instance ToJSON Endpoint where
  toJSON endpoint = object
    [ "instance" .= inst endpoint
    , "host" .= hostname endpoint
    , "ip" .= ip endpoint
    , "service" .= service endpoint
    , "method" .= method endpoint
    , "path" .= path endpoint
    ]


data Endpoints = Endpoints {
      endpoints :: [Endpoint]
    } deriving (Generic, Show)



instance ToJSON Endpoints where
    -- No need to provide a toJSON implementation.

    -- For efficiency, we write a simple toEncoding implementation, as
    -- the default version uses toJSON.
    toEncoding = genericToEncoding defaultOptions

instance FromJSON Endpoints
    -- No need to provide a parseJSON implementation.

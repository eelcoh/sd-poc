{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Service.Types
    ( Service(..)
    , Endpoint(..)
    ) where

import GHC.Generics
import Data.Aeson
import Data.Text (Text)
import qualified Data.Text as T

data Service = Service {
      endpoints :: [Endpoint]
    , hostname :: Text
    , ip :: Text
    , version :: Text
    } deriving (Generic, Show)


instance ToJSON Service where
    -- No need to provide a toJSON implementation.

    -- For efficiency, we write a simple toEncoding implementation, as
    -- the default version uses toJSON.
    toEncoding = genericToEncoding defaultOptions

instance FromJSON Service
    -- No need to provide a parseJSON implementation.

data Endpoint = Endpoint {
      method :: Text
    , path :: Text
    } deriving (Generic, Show)

instance ToJSON Endpoint where
    -- No need to provide a toJSON implementation.

    -- For efficiency, we write a simple toEncoding implementation, as
    -- the default version uses toJSON.
    toEncoding = genericToEncoding defaultOptions

instance FromJSON Endpoint
    -- No need to provide a parseJSON implementation.

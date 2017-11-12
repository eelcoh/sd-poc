{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Environment
    ( createEnvironment
    , Environment
    ) where

import GHC.Generics
import Data.Aeson
import Data.Text (Text)
import qualified Data.Text as T

import Utils.Elmify ((|>))
import Utils.Bytes (byteStringToString)

import System.Environment

createEnvironment :: IO Environment
createEnvironment =
  let
    env =
      getEnvironment
  in
    fmap toEnvironment env

toEnvironment :: [(String, String)] -> Environment
toEnvironment envrnmnt =
  let
    vars =
      [makeVar t | t <- envrnmnt]

    makeVar (k, v) =
      Variable k v

  in
    Environment vars


-- Single Variable object
data Variable = Variable {
    key :: String
  , value :: String
} deriving (Generic, Show)

instance ToJSON Variable where
    toEncoding = genericToEncoding defaultOptions

instance FromJSON Variable

-- List of permissions
data Environment = Environment {
      environment :: [Variable]
    } deriving (Generic, Show)

instance ToJSON Environment where
    toEncoding = genericToEncoding defaultOptions

instance FromJSON Environment

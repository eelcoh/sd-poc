{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Permissions
    ( get
    , getForService
    , service
    , profile
    , agreement
    , source
    , permissions
    , Permissions
    ) where

import GHC.Generics
import Data.Aeson
import Data.Text (Text)
import qualified Data.Text as T

import Utils.Elmify ((|>))
import Utils.Bytes (byteStringToString)

get :: Source -> Profile -> Permissions
get source profile =
  let
    permList =
      [p | p <- database, isForProfile p profile ]
  in
    Permissions source permList

getForService :: Source -> Profile -> Service -> Permissions
getForService source profile service =
  let
    permList =
      [p | p <- database, isForProfile p profile, isForService p service ]
  in
    Permissions source permList


-- Our 'database'
database :: [Permission]
database =
  [ Permission "John" "Savings Account 1" "View"
  , Permission "John" "Savings Account 1" "Collect"

  , Permission "Rene" "Savings Account 2" "View"
  , Permission "Rene" "Savings Account 2" "Collect"

  , Permission "John" "Savings Account 3" "View"
  , Permission "John" "Savings Account 3" "Collect"

  , Permission "Onno" "Savings Account 4" "View"
  , Permission "Onno" "Savings Account 4" "Collect"

  , Permission "Patrice" "Savings Account 5" "View"
  , Permission "Patrice" "Savings Account 5" "Collect"

  , Permission "Thijs" "Current Account 1" "View"
  , Permission "Thijs" "Current Account 1" "Initiate"
  , Permission "Thijs" "Current Account 1" "Approve"

  , Permission "Jan" "Current Account 2" "View"
  , Permission "Jan" "Current Account 2" "Initiate"
  , Permission "Jan" "Current Account 2" "Approve"

  , Permission "Eelco" "Current Account 3" "View"
  , Permission "Eelco" "Current Account 3" "Initiate"
  , Permission "Eelco" "Current Account 3" "Approve"

  , Permission "Onno" "Current Account 4" "View"
  , Permission "Onno" "Current Account 4" "Initiate"
  , Permission "Onno" "Current Account 4" "Approve"

  , Permission "John" "Current Account 5" "View"
  , Permission "John" "Current Account 5" "Initiate"
  , Permission "John" "Current Account 5" "Approve"

  , Permission "Rene" "Current Account 6" "View"
  , Permission "Rene" "Current Account 6" "Initiate"

  , Permission "Marc" "Current Account 7" "View"
  , Permission "Marc" "Current Account 7" "Initiate"
  , Permission "Marc" "Current Account 7" "Approve"

  , Permission "Marc" "Current Account 8" "View"
  , Permission "Marc" "Current Account 8" "Initiate"

  , Permission "Jean Marc" "Current Account 9" "View"
  , Permission "Jean Marc" "Current Account 9" "Initiate"
  , Permission "Jean Marc" "Current Account 9" "Approve"

  , Permission "Jean Marc" "Current Account 10" "View"
  , Permission "Jean Marc" "Current Account 10" "Initiate"

  , Permission "Allessandro" "Current Account 11" "View"
  , Permission "Allessandro" "Current Account 11" "Initiate"

  , Permission "Peter" "Current Account 11" "View"
  , Permission "Peter" "Current Account 11" "Initiate"
  , Permission "Peter" "Current Account 11" "Approve"
  ]

{-
  Check if permission's profile is the same as the one from the input
-}
isForProfile :: Permission -> Profile -> Bool
isForProfile (Permission {profile = prof1}) prof2 =
  prof1 == prof2

isForService :: Permission -> Service -> Bool
isForService (Permission {service = svc1}) svc2 =
  svc1 == svc2


{- Data models -}

-- alias for Profile
type Profile = Text

type Source = Text

type Service = Text

-- List of permissions
data Permissions = Permissions {
      source :: Source
    , permissions :: [Permission]
    } deriving (Generic, Show)

instance ToJSON Permissions where
    toEncoding = genericToEncoding defaultOptions

instance FromJSON Permissions

-- Single Permission object
data Permission = Permission {
      profile :: Profile
    , agreement :: Text
    , service :: Service
    } deriving (Generic, Show)


instance ToJSON Permission where
    -- No need to provide a toJSON implementation.

    -- For efficiency, we write a simple toEncoding implementation, as
    -- the default version uses toJSON.
    toEncoding = genericToEncoding defaultOptions

instance FromJSON Permission
    -- No need to provide a parseJSON implementation.

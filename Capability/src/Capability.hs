{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Capability
    ( getAccountBalancesForProfile
    , Accounts
    ) where

import GHC.Generics
import Data.Aeson
import Data.Text (Text)
import qualified Data.Text as T

import Utils.Elmify ((|>))
import Utils.Bytes (byteStringToString)

import Data.List

import qualified Permissions

getAccountBalancesForProfile :: Profile -> Accounts
getAccountBalancesForProfile profile =
  let
    permissions =
      Permissions.getForService "not yet" profile "view"

    accountsForPermissions =
      Permissions.permissions permissions
      |> fmap Permissions.agreement
      |> getAccountsForIds database

    makeAccounts acts =
       Accounts profile acts

  in
    makeAccounts accountsForPermissions


-- Our 'database'
database :: [Account]
database =
  [ Account "Savings Account 1" "John's Savings Account 1" 21.00
  , Account "Savings Account 2" "Rene's Savings Account 2" 22.00
  , Account "Savings Account 3" "John's Savings Account 3" 23.00
  , Account "Savings Account 4" "Onno's Savings Account 4" 24.00
  , Account "Savings Account 5" "Patrice's Savings Account 5" 25.00
  , Account "Current Account 1" "Thijs's Current Account 1" 101.01
  , Account "Current Account 2" "Jan's Current Account 2" 102.02
  , Account "Current Account 3" "Eelco's Current Account 3" 103.03
  , Account "Current Account 4" "Onno's Current Account 4" 104.04
  , Account "Current Account 5" "John's Current Account 5" 105.05
  , Account "Current Account 6" "Rene's Current Account 6" 106.06
  , Account "Current Account 7" "Marc's Current Account 7" 107.07
  , Account "Current Account 8" "Marc's Current Account 8" 108.08
  , Account "Current Account 9" "Jean Marc's Current Account 9" 109.09
  , Account "Current Account 10" "Jean Marc's Current Account 10" 110.10
  , Account "Current Account 11" "Allessandro's & Peter''s Current Account 11" 111.11
  ]

{-
  Check if permission's profile is the same as the one from the input
-}
getAccountsForIds :: [Account] -> [AccountId] -> [Account]
getAccountsForIds accounts accountIds =
  let
    isRequested (Account {accountId = accntId}) =
      elem accntId accountIds
  in
    [ account | account <- accounts, isRequested account ]


{- Data models -}

-- alias for Profile
type Profile = Text

-- alias for AccountId
type AccountId = Text

-- List of accounts
data Accounts = Accounts {
      profile :: Profile
    , accounts :: [Account]
    } deriving (Generic, Show)

instance ToJSON Accounts where
    toEncoding = genericToEncoding defaultOptions

instance FromJSON Accounts

-- Single Account object
data Account = Account {
      accountId :: AccountId
    , accountName :: Text
    , balance :: Double
    } deriving (Generic, Show)


instance ToJSON Account where
    -- No need to provide a toJSON implementation.

    -- For efficiency, we write a simple toEncoding implementation, as
    -- the default version uses toJSON.
    toEncoding = genericToEncoding defaultOptions

instance FromJSON Account
    -- No need to provide a parseJSON implementation.

{-# LANGUAGE OverloadedStrings #-}

module Utils.Bytes
    ( byteStringToString
    , c2w
    , w2c
    ) where

import qualified Data.ByteString.Lazy as B
import Data.Word (Word8)
import Data.Char (ord)
import GHC.Base (unsafeChr)
import Utils.Elmify ((|>))

byteStringToString :: B.ByteString -> [Char]
byteStringToString bs =
  B.unpack bs
  |> map w2c

c2w :: Char -> Word8
c2w = fromIntegral . ord

w2c :: Word8 -> Char
w2c = unsafeChr . fromIntegral

{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE OverloadedStrings  #-}

module EAcoins where

import           PlutusTx                        (BuiltinData, compile, unstableMakeIsData, makeIsDataIndexed)
import           PlutusTx.Prelude                (Bool (..),traceIfFalse, otherwise, Integer, ($), (<=), (&&), (>))
import           Plutus.V2.Ledger.Api            (CurrencySymbol, MintingPolicy, ScriptContext, mkMintingPolicyScript)
import           Plutus.V2.Ledger.Api            as PlutusV2
import           Plutus.V1.Ledger.Value          as PlutusV1
import           Plutus.V1.Ledger.Interval      (contains, to) 
import           Plutus.V2.Ledger.Contexts      (txSignedBy, valueSpent, ownCurrencySymbol)
--Serialization
import           Mappers                (wrapPolicy)
import           Serialization          (currencySymbol, writePolicyToFile,  writeDataToFile) 
import           Prelude                (IO)


-- ON-CHAIN CODE

data Action = Owner | Time | Price
unstableMakeIsData ''Action

data OurRedeemer = OR { action :: Action
                   , owner :: PubKeyHash
                   , timelimit :: POSIXTime
                   , price :: Integer }

unstableMakeIsData ''OurRedeemer

data TwoSignReedem = TwoSignReedem { signer1 :: PubKeyHash
                                    , signer2 :: PubKeyHash}

unstableMakeIsData ''TwoSignReedem

{-# INLINABLE eaCoins #-}
eaCoins :: OurRedeemer -> ScriptContext -> Bool
eaCoins redeemer sContext = case action redeemer of
                            Owner   -> traceIfFalse    "Not signed properly!"  signedByOwner
                            Time    -> traceIfFalse    "Your run out of time!" timeLimitNotReached                                         
                            Price   -> traceIfFalse    "Price is not covered"  priceIsCovered
    where
        signedByOwner :: Bool
        signedByOwner = txSignedBy info $ owner redeemer

        timeLimitNotReached :: Bool
        timeLimitNotReached = contains (to $ timelimit redeemer) $ txInfoValidRange info 

        priceIsCovered :: Bool
        priceIsCovered =  assetClassValueOf (valueSpent info)  (AssetClass (adaSymbol,adaToken)) > price redeemer

        info :: TxInfo
        info = scriptContextTxInfo sContext



{-# INLINABLE eaRyanCoin #-}
eaRyanCoin :: TwoSignReedem -> ScriptContext -> Bool 
eaRyanCoin redeem ctx = traceIfFalse "signer 1 did not sign" sign1 &&
                            traceIfFalse "signer 1 did not sign" sign2
    where
        sign1 :: Bool
        sign1 = txSignedBy info $ signer1 redeem 

        sign2 :: Bool 
        sign2 = txSignedBy info $ signer2 redeem 

        info :: TxInfo
        info = scriptContextTxInfo ctx 


{-# INLINABLE wrappedEAcoinsPolicy #-}
wrappedEAcoinsPolicy :: BuiltinData -> BuiltinData -> ()
wrappedEAcoinsPolicy = wrapPolicy eaCoins

eaCoinsPolicy :: MintingPolicy
eaCoinsPolicy = mkMintingPolicyScript $$(PlutusTx.compile [|| wrappedEAcoinsPolicy ||])


{-# INLINABLE wrappedRyancoinsPolicy #-}
wrappedRyancoinsPolicy :: BuiltinData -> BuiltinData -> ()
wrappedRyancoinsPolicy = wrapPolicy eaRyanCoin

eaRyanCoinsPolicy :: MintingPolicy
eaRyanCoinsPolicy = mkMintingPolicyScript $$(PlutusTx.compile [|| wrappedRyancoinsPolicy ||])

-- Serialised Scripts and Values 

saveEAcoinsPolicy :: IO ()
saveEAcoinsPolicy = writePolicyToFile "testnet/EAcoins.plutus" eaCoinsPolicy

saveRyancoinsPolicy :: IO ()
saveRyancoinsPolicy = writePolicyToFile "testnet/RyanCoins.plutus" eaRyanCoinsPolicy

saveTwoSignerReedem :: IO ()
saveTwoSignerReedem = writeDataToFile "./testnet/twoSignRedeem.json" (TwoSignReedem "9a18f3275fedf12dbe8cedb6c6489a683685ec7436a12766dbb91733" "9c894a0ee5ae77ca1618f5a7d840d9c7c32d92216ffb769faac7091c")  --PKH of Addr1 and Addr2 

saveUnit :: IO ()
saveUnit = writeDataToFile "./testnet/unit.json" ()

saveRedeemerOwner :: IO ()
saveRedeemerOwner = writeDataToFile "./testnet/redeemOwner.json" Owner

saveRedeemerTime :: IO ()
saveRedeemerTime = writeDataToFile "./testnet/redeemTime.json" Time

saveRedeemerPrice :: IO ()
saveRedeemerPrice = writeDataToFile "./testnet/redeemPrice.json" Price

saveOR :: IO ()
saveOR = writeDataToFile "./testnet/ourRedeem.json" (OR Owner "9a18f3275fedf12dbe8cedb6c6489a683685ec7436a12766dbb91733" 1686837045000 50)  --PKH of Addr1


saveAll :: IO ()
saveAll = do
            saveEAcoinsPolicy
            saveUnit
            saveRedeemerOwner
            saveRedeemerPrice
            saveRedeemerTime
            saveOR
            saveRyancoinsPolicy
            saveTwoSignerReedem


            
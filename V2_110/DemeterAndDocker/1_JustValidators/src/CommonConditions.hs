{-# LANGUAGE DataKinds           #-}  --Enable datatype promotions
{-# LANGUAGE NoImplicitPrelude   #-}  --Don't load native prelude to avoid conflict with PlutusTx.Prelude
{-# LANGUAGE TemplateHaskell     #-}  --Enable Template Haskell splice and quotation syntax
{-# LANGUAGE OverloadedStrings   #-}  --Enable passing strings as other character formats, like bytestring.

module CommonConditions where

--PlutusTx 
import                  PlutusTx                       (BuiltinData, compile, unstableMakeIsData, makeIsDataIndexed)
import                  PlutusTx.Prelude               (traceIfFalse, otherwise, (==), Bool (..), Integer, ($), (>),(&&),(*))
import                  Plutus.V1.Ledger.Value      as PlutusV1
import                  Plutus.V1.Ledger.Interval      (contains, to) 
import                  Plutus.V2.Ledger.Api        as PlutusV2
import                  Plutus.V2.Ledger.Contexts      (txSignedBy, valueSpent)
--Serialization
import                  Mappers                        (wrapValidator)
import                  Serialization                  (writeValidatorToFile, writeDataToFile)
import                  Prelude                         (IO)

--THE ON-CHAIN CODE
data ConditionsDatum = Conditions { owner :: PubKeyHash
                                  , timelimit :: POSIXTime
                                  , price :: Integer
                                  }
unstableMakeIsData ''ConditionsDatum

data ActionsRedeemer = Owner | Time | Price
unstableMakeIsData '' ActionsRedeemer


{-# INLINABLE conditionator #-}
conditionator :: ConditionsDatum -> ActionsRedeemer -> ScriptContext -> Bool
conditionator datum redeemer sContext = case redeemer of
                                         Owner   -> traceIfFalse    "Not signed properly!"  signedByOwner
                                         Time    -> traceIfFalse    "Your run out of time!" timeLimitNotReached                                         
                                         Price   -> traceIfFalse    "Price is not covered"  priceIsCovered
    where
        signedByOwner :: Bool
        signedByOwner = txSignedBy info $ owner datum

        timeLimitNotReached :: Bool
        timeLimitNotReached = contains (to $ timelimit datum) $ txInfoValidRange info 

        priceIsCovered :: Bool
        priceIsCovered =  assetClassValueOf (valueSpent info)  (AssetClass (adaSymbol,adaToken)) > price datum

        info :: TxInfo
        info = scriptContextTxInfo sContext


{-# INLINABLE handsOn3 #-}
handsOn3 :: ConditionsDatum -> Bool -> ScriptContext -> Bool 
handsOn3 _ False _      = False 
handsOn3 datum True ctx = traceIfFalse "not signed properly" signed &&
                          traceIfFalse "deadlinereached" deadlineReached &&
                          traceIfFalse "price is invalid" priceValid   
    where    

        info :: TxInfo 
        info = scriptContextTxInfo ctx
        
        signed :: Bool 
        signed = txSignedBy info $ owner datum 

        deadlineReached :: Bool 
        deadlineReached = contains (to $ timelimit datum) (txInfoValidRange info)

        priceValid :: Bool 
        priceValid = assetClassValueOf (valueSpent info) (AssetClass (adaSymbol,adaToken)) > price datum * 2


       
mappedhandsOn3 :: BuiltinData -> BuiltinData -> BuiltinData -> ()
mappedhandsOn3 = wrapValidator handsOn3

handsOn3Validator :: Validator
handsOn3Validator =  PlutusV2.mkValidatorScript $$(PlutusTx.compile [|| mappedhandsOn3 ||])



mappedCommonConditions :: BuiltinData -> BuiltinData -> BuiltinData -> ()
mappedCommonConditions = wrapValidator conditionator

conditionsValidator :: Validator
conditionsValidator =  PlutusV2.mkValidatorScript $$(PlutusTx.compile [|| mappedCommonConditions ||])

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

{- Serialised Scripts and Values -}

saveConditionsValidator :: IO ()
saveConditionsValidator =  writeValidatorToFile "./testnet/conditionator.plutus" conditionsValidator

savehandsOn3Validator :: IO ()
savehandsOn3Validator =  writeValidatorToFile "./testnet/handsOn3.plutus" handsOn3Validator

saveUnit :: IO ()
saveUnit = writeDataToFile "./testnet/unit.json" ()

saveDatum :: IO ()
saveDatum  = writeDataToFile "./testnet/datum.json" (Conditions "" 1686837045000 50)

savehandsOn3Datum :: IO ()
savehandsOn3Datum  = writeDataToFile "./testnet/handsOn3datum.json" (Conditions "9a18f3275fedf12dbe8cedb6c6489a683685ec7436a12766dbb91733" 1710519703000 10)  --Addr1.pkh 

saveRedeemerOwner :: IO ()
saveRedeemerOwner = writeDataToFile "./testnet/redeemOwner.json" Owner

saveRedeemerTime :: IO ()
saveRedeemerTime = writeDataToFile "./testnet/redeemTime.json" Time

saveRedeemerPrice :: IO ()
saveRedeemerPrice = writeDataToFile "./testnet/redeemPrice.json" Price

saveRedeemTrue :: IO ()
saveRedeemTrue = writeDataToFile "./testnet/redeemTrue.json" True

saveRedeemFalse :: IO ()
saveRedeemFalse = writeDataToFile "./testnet/redeemFalse.json" False

saveAll :: IO ()
saveAll = do
            savehandsOn3Validator
            --saveConditionsValidator
            saveUnit
            --saveDatum
            saveRedeemerOwner
            saveRedeemerPrice
            saveRedeemerTime
            savehandsOn3Datum
            saveRedeemFalse
            saveRedeemTrue
            

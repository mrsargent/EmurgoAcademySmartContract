{-# LANGUAGE DataKinds           #-}  --Enable datatype promotions
{-# LANGUAGE NoImplicitPrelude   #-}  --Don't load native prelude to avoid conflict with PlutusTx.Prelude
{-# LANGUAGE TemplateHaskell     #-}  --Enable Template Haskell splice and quotation syntax
{-# LANGUAGE OverloadedStrings   #-}  --Enable passing strings as other character formats, like bytestring.

module MathBounty where

--PlutusTx 
import                  PlutusTx                       (BuiltinData, compile, unstableMakeIsData, makeIsDataIndexed)
import                  PlutusTx.Prelude               (traceIfFalse, otherwise, (==), Bool (..), Integer, ($), (>), (+), (&&), (++))
import                  Plutus.V1.Ledger.Value      as PlutusV1
import                  Plutus.V1.Ledger.Interval      (contains, to) 
import                  Plutus.V2.Ledger.Api        as PlutusV2
import                  Plutus.V2.Ledger.Contexts      (txSignedBy, valueSpent)
--Serialization
import                  Mappers                        (wrapValidator)
import                  Serialization                  (writeValidatorToFile, writeDataToFile)
import                  Prelude                         (IO,show,return)

--THE ON-CHAIN CODE
data BountyConditions = BC { theX :: Integer
                           , deadline :: POSIXTime
                           }
unstableMakeIsData ''BountyConditions


{-# INLINABLE mathBounty #-}
mathBounty :: BountyConditions -> Integer -> ScriptContext -> Bool
mathBounty datum redeemer sContext = traceIfFalse "Wrong amswer!" ((theX datum) + redeemer == 25) &&
                                     traceIfFalse "Deadline reached!" deadlineNotReached

    where
        deadlineNotReached :: Bool
        deadlineNotReached = contains (to $ deadline datum) $ txInfoValidRange info 

        info :: TxInfo
        info = scriptContextTxInfo sContext


mappedMathBounty :: BuiltinData -> BuiltinData -> BuiltinData -> ()
mappedMathBounty = wrapValidator mathBounty

mathBountyValidator :: Validator
mathBountyValidator =  PlutusV2.mkValidatorScript $$(PlutusTx.compile [|| mappedMathBounty ||])

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

{- Serialised Scripts and Values -}

saveMathBountyValidator :: IO ()
saveMathBountyValidator =  writeValidatorToFile "./testnet/mathBounty.plutus" mathBountyValidator

saveDatum :: IO ()
saveDatum = writeDataToFile "./testnet/bountyConditions.json" BC { theX = 12
                                                                 , deadline = 1711321242000
                                                                 }

saveTheY :: IO ()
saveTheY = writeDataToFile "./testnet/value-5.json" (-5::Integer) 

redeem13 :: IO ()
redeem13 = writeDataToFile "./testnet/redeem13.json" (13::Integer) 

saveAll :: IO ()
saveAll = do
           saveMathBountyValidator
           saveDatum
           saveTheY
           redeem13

saveRecursiveWrites :: IO ()
saveRecursiveWrites = do 
    recursiveWrite [12,13,25,43]

recursiveWrite :: [Integer] -> IO ()
recursiveWrite [] = return ()  
recursiveWrite (x:xs) = do
    let str = "./testnet/RyanTest/bountyConiditions" ++ show x 
    writeDataToFile str BC { theX = x , deadline = 1711321242000} 
    recursiveWrite xs


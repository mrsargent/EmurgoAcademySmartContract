{-# LANGUAGE DataKinds           #-}  --Enable datatype promotions
{-# LANGUAGE NoImplicitPrelude   #-}  --Don't load native prelude to avoid conflict with PlutusTx.Prelude
{-# LANGUAGE TemplateHaskell     #-}  --Enable Template Haskell splice and quotation syntax
{-# LANGUAGE OverloadedStrings   #-}  --Enable passing strings as other character formats, like bytestring.

module Handson4 where

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

newtype Handson4Datum = Handson4Datum { pkhs :: [PubKeyHash]}
unstableMakeIsData ''Handson4Datum

{-# INLINABLE handsOn4Validator #-}
handsOn4SC :: Handson4Datum -> Bool -> ScriptContext -> Bool
handsOn4SC _ False _     = False
handsOn4SC datum _ ctx   = traceIfFalse "bad multisig" signedMultiSig
    where
        info :: TxInfo 
        info = scriptContextTxInfo ctx 

        signedMultiSig :: Bool
        signedMultiSig = txInfoSignatories info == pkhs datum  


mappedhandsOn4 :: BuiltinData -> BuiltinData -> BuiltinData -> ()
mappedhandsOn4 = wrapValidator handsOn4SC

handsOn4Validator :: Validator
handsOn4Validator =  PlutusV2.mkValidatorScript $$(PlutusTx.compile [|| mappedhandsOn4 ||])


saveHandsOn4Validator :: IO ()
saveHandsOn4Validator =  writeValidatorToFile "./testnet/handsOn4.plutus" handsOn4Validator


savehandsOn4Datum :: IO ()
savehandsOn4Datum  = writeDataToFile "./testnet/handsOn4datum.json" (Handson4Datum ["9a18f3275fedf12dbe8cedb6c6489a683685ec7436a12766dbb91733","9c894a0ee5ae77ca1618f5a7d840d9c7c32d92216ffb769faac7091c"]) -- [Addr1.pkh,Addr2.pkh]


saveAll :: IO ()
saveAll = do
        saveHandsOn4Validator
        savehandsOn4Datum

        
        
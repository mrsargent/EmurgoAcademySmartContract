{-# LANGUAGE DataKinds           #-}  --Enable datatype promotions
{-# LANGUAGE NoImplicitPrelude   #-}  --Don't load native prelude to avoid conflict with PlutusTx.Prelude
{-# LANGUAGE TemplateHaskell     #-}  --Enable Template Haskell splice and quotation syntax
{-# LANGUAGE OverloadedStrings   #-}  --Enable passing strings as other character formats, like bytestring.

module TypedValidators where

--PlutusTx 
import                  PlutusTx                       (BuiltinData, compile,unstableMakeIsData, makeIsDataIndexed)
import                  PlutusTx.Prelude               (traceIfFalse, otherwise, (==), Bool (..), Integer, ($))
import                  Plutus.V2.Ledger.Api        as PlutusV2
--Serialization
import                  Mappers                        (wrapValidator)
import                  Serialization                  (writeValidatorToFile, writeDataToFile)
import                  Prelude                     (IO)

--import Data.Bool (Bool(True))
--import Distribution.Simple.Setup (TestFlags(testFailWhenNoTestSuites))

------------------------------------------------------------------------------------------
-- Primites Types
------------------------------------------------------------------------------------------

{-# INLINABLE typedDatum22 #-}
typedDatum22 :: Integer -> () -> ScriptContext -> Bool
typedDatum22 datum _ _ = traceIfFalse "Not the right datum!" (datum ==  22)

{-# INLINABLE typedRedeemer11 #-}
typedRedeemer11 ::  () -> Integer -> ScriptContext -> Bool
typedRedeemer11 _ redeemer _ = traceIfFalse "Not the right redeemer!" (redeemer ==  11)

------------------------------------------------------------------------------------------
-- Custom Types
------------------------------------------------------------------------------------------
{-
newtype OurWonderfullDatum = OWD Integer
unstableMakeIsData ''OurWonderfullDatum

data OurWonderfullRedeemer = OWR Integer | JOKER Bool
makeIsDataIndexed ''OurWonderfullRedeemer [('OWR,0),('JOKER,1)]
-}

data RyanCustomTest = RCT Integer | ROBIN Bool | EmptyRCT 
--unstableMakeIsData ''RyanCustomTest 
makeIsDataIndexed ''RyanCustomTest [('RCT,42),('ROBIN,101),('EmptyRCT,30)]

data OurWonderfullDatum = OWD Integer | BATMAN Bool | EmptyDatum
unstableMakeIsData ''OurWonderfullDatum

data OurWonderfullRedeemer = OWR Integer | JOKER Bool | EmptyRedeemer
unstableMakeIsData ''OurWonderfullRedeemer 

--my custom function
{-# INLINABLE cDeR #-}
cDeR :: OurWonderfullDatum -> OurWonderfullRedeemer -> ScriptContext -> Bool 
cDeR (OWD d) (OWR r) _          = traceIfFalse "datum and redeemer not equal" $ d == r
cDeR (BATMAN d) (JOKER r) _     = traceIfFalse "datum and redeemer not equal" $ d == r
cDeR (OWD d) (JOKER r) _        = traceIfFalse "different types" False 
cDeR (BATMAN d) (OWR r) _       = traceIfFalse "different types" False 
cDeR EmptyDatum EmptyRedeemer _ = True

{-# INLINABLE customTypedDatum22 #-}
customTypedDatum22 :: OurWonderfullDatum -> () -> ScriptContext -> Bool
customTypedDatum22 (OWD datum) _ _ = traceIfFalse "Not the right datum!" (datum ==  22)

{-# INLINABLE customTypedRedeemer11 #-}
customTypedRedeemer11 ::  () -> OurWonderfullRedeemer -> ScriptContext -> Bool
customTypedRedeemer11 _ (OWR number) _    =  traceIfFalse "Not the right redeemer!" (number ==  11)
customTypedRedeemer11 _ (JOKER boolean) _ =  traceIfFalse "The Joker sais no!" boolean


------------------------------------------------------------------------------------------
-- Mappers and Compiling expresions
------------------------------------------------------------------------------------------

-- for primitives types

mappedTypedDatum22 :: BuiltinData -> BuiltinData -> BuiltinData -> ()
mappedTypedDatum22 = wrapValidator customTypedDatum22

typedDatum22Val :: PlutusV2.Validator
typedDatum22Val = PlutusV2.mkValidatorScript $$(PlutusTx.compile [|| mappedTypedDatum22 ||])

mappedTypedRedeemer11 :: BuiltinData -> BuiltinData -> BuiltinData -> ()
mappedTypedRedeemer11 = wrapValidator typedRedeemer11

typedRedeemer11Val :: Validator
typedRedeemer11Val = PlutusV2.mkValidatorScript $$(PlutusTx.compile [|| mappedTypedRedeemer11 ||])


-- for custom types

mappedCustomTypedDatum22 :: BuiltinData -> BuiltinData -> BuiltinData -> ()
mappedCustomTypedDatum22 = wrapValidator customTypedDatum22

mappedCustomTypedRedeemer11 :: BuiltinData -> BuiltinData -> BuiltinData -> ()
mappedCustomTypedRedeemer11 = wrapValidator customTypedRedeemer11

customTypedDatum22Val :: Validator
customTypedDatum22Val = PlutusV2.mkValidatorScript $$(PlutusTx.compile [|| mappedCustomTypedDatum22 ||])

customTypedRedeemer11Val :: Validator
customTypedRedeemer11Val = PlutusV2.mkValidatorScript $$(PlutusTx.compile [|| mappedCustomTypedRedeemer11 ||])

--my function for turning back in to BuiltinData
mappedDeR :: BuiltinData -> BuiltinData -> BuiltinData -> () 
mappedDeR = wrapValidator cDeR 

customDeR :: Validator 
customDeR = PlutusV2.mkValidatorScript $$(PlutusTx.compile [|| mappedDeR ||])

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

{- Serialised Scripts and Values -}
--my functions to save the data
saveDeR :: IO()
saveDeR = writeValidatorToFile "./testnet/cDeR.plutus" customDeR


saveTypedDatum22 :: IO ()
saveTypedDatum22 =  writeValidatorToFile "./testnet/typedDatum22.plutus" typedDatum22Val

saveTypedRedeemer11 :: IO ()
saveTypedRedeemer11 =  writeValidatorToFile "./testnet/typedRedeemer11.plutus" typedRedeemer11Val

saveCustomTypedDatum22 :: IO ()
saveCustomTypedDatum22 =  writeValidatorToFile "./testnet/customTypedDatum22.plutus" customTypedDatum22Val

saveCustomTypedRedeemer11 :: IO ()
saveCustomTypedRedeemer11 =  writeValidatorToFile "./testnet/customTypedRedeemer11.plutus" customTypedRedeemer11Val

saveUnit :: IO ()
saveUnit = writeDataToFile "./testnet/unit.json" ()

saveValue11 :: IO ()
saveValue11 = writeDataToFile "./testnet/value11.json" (11 :: Integer)

saveValue22 :: IO ()
saveValue22 = writeDataToFile "./testnet/value22.json" (22 :: Integer)

saveGoodDatum  :: IO ()
saveGoodDatum = writeDataToFile "./testnet/goodOWD.json" (OWD 22)

saveBadDatum  :: IO ()
saveBadDatum = writeDataToFile "./testnet/badOWD.json" (OWD 23)

saveOWR  :: IO ()
saveOWR = writeDataToFile "./testnet/OWR.json" ()

saveGoodJOKER :: IO ()
saveGoodJOKER = writeDataToFile "./testnet/GoodJokerAutoIndex.json" (JOKER True)

saveBadJOKER :: IO ()
saveBadJOKER = writeDataToFile "./testnet/BadJokerAutoIndex.json" (JOKER False)

saveDatum33  :: IO ()
saveDatum33 = writeDataToFile "./testnet/datum33.json" (OWD 33)

saveRedeem33  :: IO ()
saveRedeem33 = writeDataToFile "./testnet/redeem33.json" (OWR 33)

saveGoodBatman :: IO ()
saveGoodBatman = writeDataToFile "./testnet/GoodBatman.json" (BATMAN True)

saveBadBatman :: IO ()
saveBadBatman = writeDataToFile "./testnet/BadBatman.json" (BATMAN False)

saveEmptyDatum :: IO ()
saveEmptyDatum = writeDataToFile "./testnet/EmptyDatum.json" EmptyDatum

saveEmptyRedeem :: IO ()
saveEmptyRedeem = writeDataToFile "./testnet/EmptyRedeem.json" EmptyRedeemer


saveAll :: IO ()
saveAll = do
            saveTypedDatum22
            saveTypedRedeemer11
            saveCustomTypedDatum22
            saveCustomTypedRedeemer11
            saveUnit
            saveValue11
            saveValue22
            saveGoodDatum
            saveBadDatum
            saveOWR
            saveGoodJOKER
            saveBadJOKER
            saveDeR
            saveDatum33
            saveRedeem33
            saveGoodBatman
            saveBadBatman
            saveEmptyDatum
            saveEmptyRedeem


saveTestTypeNumber :: IO ()
saveTestTypeNumber = writeDataToFile "./testnet/TestTypeNumber.json" (RCT 33)

saveTestTypeBool :: IO ()
saveTestTypeBool = writeDataToFile "./testnet/TestTypeBool.json" (ROBIN True)

saveTestTypeEmpty :: IO ()
saveTestTypeEmpty = writeDataToFile "./testnet/TestTypeEmpty.json" EmptyRCT

saveTest :: IO ()
saveTest = do
            saveTestTypeNumber
            saveTestTypeBool
            saveTestTypeEmpty



            
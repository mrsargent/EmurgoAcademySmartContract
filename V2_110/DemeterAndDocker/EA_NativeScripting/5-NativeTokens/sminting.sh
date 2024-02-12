utxoin="518ced66d03c090eac406b39b6d765d5b223d23d0b0856be9bee73a5d1f878b0#1"
policyid=$(cat policyB107.id)
address="addr_test1qpc6mrwu9cucrq4w6y69qchflvypq76a47ylvjvm2wph4szeq579yu2z8s4m4tn0a9g4gfce50p25afc24knsf6pj96sz35wnt"
output="11000000"
tokenname=$(echo -n "RyanIsAwesomeCoin" | xxd -ps | tr -d '\n')
tokenammount="501"
collateral="c6c1d04f61ee6845876f5c8513f366661cb410e0bb8dde958e36f23d240eb186#0"
signerPKH="1aac37c39f0341089f5c6b3e96034c1d7ce82c05b587c44086b9fb7e"


cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  --testnet-magic 2 \
  --tx-in $utxoin \
  --required-signer-hash $signerPKH \
  --tx-in-collateral $collateral \
  --tx-out $address+$output+"$tokenammount $policyid.$tokenname" \
  --change-address $AdrBatch \
  --mint "$tokenammount $policyid.$tokenname" \
  --mint-script-file policyB107.script \
  --invalid-hereafter 41079559 \
  --protocol-params-file protocol.params \
  --out-file sminting.unsigned

cardano-cli transaction sign \
  --tx-body-file sminting.unsigned \
  --signing-key-file ../1-SimplePayment/batch107.skey \
  --testnet-magic 2 \
  --out-file sminting.signed

 cardano-cli transaction submit \
  --testnet-magic 2 \
  --tx-file sminting.signed
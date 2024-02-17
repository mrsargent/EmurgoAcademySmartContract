utxoin="7d4ee1afb8c0d3fcbd373cee06a3028f883943097ea939a7ee00a73f14b3e6bb#1"
policyid=$(cat RyanNFTpolicy.id)
address="addr_test1qpc6mrwu9cucrq4w6y69qchflvypq76a47ylvjvm2wph4szeq579yu2z8s4m4tn0a9g4gfce50p25afc24knsf6pj96sz35wnt"  #destination address... where I am sending the nft to 
output="20000000"
tokenname="5279616e535f4e4654" #$(echo -n "RyanS_NFT" | xxd -ps | tr -d '\n')
tokenammount="1" #nft is only allowed 1
collateral="9d10f7d50777c69a7764ee56edcc62b25935ea2709e79db82700a95903a9a692#0"
signerPKH="1aac37c39f0341089f5c6b3e96034c1d7ce82c05b587c44086b9fb7e"

#cardano-cli transaction policyid --script-file NFTpolicy.script > NFTpolicy.id

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params
#note: on teh signing-key-file.  I only had 1 key sign because that one key provided the utxo to send, and the colateral, and the minting policy. 
# if I had other keys doing other thigns they would need to be there as well
cardano-cli transaction build \
  --babbage-era \
  --testnet-magic 2 \
  --tx-in $utxoin \
  --required-signer-hash $signerPKH \
  --tx-in-collateral $collateral \
  --tx-out $address+$output+"$tokenammount $policyid.$tokenname" \
  --change-address $AdrBatch \
  --mint "$tokenammount $policyid.$tokenname" \
  --mint-script-file RyanNFTpolicy.script \
  --invalid-hereafter 42212182 \
  --metadata-json-file RyanNFTMetadata.json \
  --protocol-params-file protocol.params \
  --out-file NFTminting.unsigned

cardano-cli transaction sign \
  --tx-body-file NFTminting.unsigned \
  --signing-key-file ../1-SimplePayment/batch107.skey \
  --testnet-magic 2 \
  --out-file NFTminting.signed

 cardano-cli transaction submit \
  --testnet-magic 2 \
  --tx-file NFTminting.signed
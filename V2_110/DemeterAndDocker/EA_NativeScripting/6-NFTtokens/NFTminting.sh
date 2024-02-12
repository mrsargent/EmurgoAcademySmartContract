utxoin="c6c1d04f61ee6845876f5c8513f366661cb410e0bb8dde958e36f23d240eb186#0"
policyid=$(cat RyanNFTpolicy.id)
address="addr_test1qpc6mrwu9cucrq4w6y69qchflvypq76a47ylvjvm2wph4szeq579yu2z8s4m4tn0a9g4gfce50p25afc24knsf6pj96sz35wnt"  #destination address... where I am sending the nft to 
output="20000000"
tokenname="5279616e535f4e4654" #$(echo -n "RyanS_NFT" | xxd -ps | tr -d '\n')
tokenammount="1"  #nft is only allowed 1
collateral="9e2b4cc334e5a726f32bb0727a6c735a4e0e3d2754418e0422787a9f330ed294#1"
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
  --invalid-hereafter 41212182 \
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
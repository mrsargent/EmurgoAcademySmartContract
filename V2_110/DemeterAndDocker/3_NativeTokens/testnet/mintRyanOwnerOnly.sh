utxoin1="9f30e823547ac13c2ed1d116e16cbe7be854be557e062ad75981b94516db7ead#0"
policyid=$(cat EAcoins.pid)
nami="addr_test1qpc6mrwu9cucrq4w6y69qchflvypq76a47ylvjvm2wph4szeq579yu2z8s4m4tn0a9g4gfce50p25afc24knsf6pj96sz35wnt"
output="12000000"
tokenamount="10000"
tokenname="5279616e44696e65726f"   #$(echo -n "RyanDinero" | xxd -ps | tr -d '\n')
collateral="9ee1a1ebcc933d65aaf99593f661c644f001782ef37c744aff3e1b21a453e63c#0"  #Addr2
signerPKH="9c894a0ee5ae77ca1618f5a7d840d9c7c32d92216ffb769faac7091c"  #pkh of Addr2
txTimeInterval="--invalid-hereafter 10962786"
PREVIEW="--testnet-magic 2"

#notes: the txTimeInterval is shown up in the scriptcontext if it was sent in transaction  
#notes: the reqiured-signer-has in the transaciton build there required-signer-has is required to send to the sript context
      # in order to compare it to the redeemer pkh.  becaues... as you know the information in teh script context is the information
      # in the transaction build

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin1 \
  --required-signer-hash "9a18f3275fedf12dbe8cedb6c6489a683685ec7436a12766dbb91733" \
  --required-signer-hash $signerPKH \
  --tx-in-collateral $collateral \
  --tx-out $nami+$output+"$tokenamount $policyid.$tokenname" \
  --change-address $Addr1 \
  --mint "$tokenamount $policyid.$tokenname" \
  --mint-script-file EAcoins.plutus \
  --mint-redeemer-file ourRedeem.json \
  --protocol-params-file protocol.params \
  --out-file mintRyan.body

cardano-cli transaction sign \
    --tx-body-file mintRyan.body \
    --signing-key-file ../../Wallet/Addr1.skey \
    --signing-key-file ../../Wallet/Addr2.skey \
    $PREVIEW \
    --out-file mintRyan.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file mintRyan.signed
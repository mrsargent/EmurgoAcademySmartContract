utxoin="36727be79e901b4a0701a4ea98d5b04fed1906362e49e6b560ad50f8a09b68ac#1"
address=$(cat handsOn3.addr) 
output="40000000"
changeAddress=$(cat ../../Wallet/Addr1.addr) 
PREVIEW="--testnet-magic 2"

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin \
  --tx-out $address+$output \
  --tx-out-reference-script-file handsOn3.plutus \
  --tx-out-inline-datum-file handsOn3datum.json \
  --change-address $changeAddress \
  --protocol-params-file protocol.params \
  --out-file giveHands3.unsigned

cardano-cli transaction sign \
    --tx-body-file giveHands3.unsigned \
    --signing-key-file ../../Wallet/Addr1.skey \
    $PREVIEW \
    --out-file giveHands3.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file giveHands3.signed
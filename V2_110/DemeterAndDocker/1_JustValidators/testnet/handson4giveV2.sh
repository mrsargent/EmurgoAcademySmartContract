utxoin1="248e0421296958b036dcff18f9888580f8a46db791fd05f242b31449b8ddad7b#1"
utxoin2="0baedc3a9f6fcd17bba4897642f972f5b31c094d7ff4543bcabff7e7dfa7b6fc#1"
address=$(cat handsOn4.addr) 
output="30000000"
changeAddress=$(cat ../../Wallet/Addr1.addr) 
PREVIEW="--testnet-magic 2"

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin1 \
  --tx-in $utxoin2 \
  --tx-out $address+$output \
  --tx-out-reference-script-file handsOn4.plutus \
  --tx-out-inline-datum-file handsOn4datum.json \
  --change-address $changeAddress \
  --protocol-params-file protocol.params \
  --out-file giveHands4.unsigned

cardano-cli transaction sign \
    --tx-body-file giveHands4.unsigned \
    --signing-key-file ../../Wallet/Addr1.skey \
    --signing-key-file ../../Wallet/Addr2.skey \
    $PREVIEW \
    --out-file giveHands4.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file giveHands4.signed
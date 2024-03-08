utxoin="2bcded04aff11a3ea7c4ffc678a16b43e88297c750764b63b31a74c5215af454#5"
address=$(cat cDeR.addr) 
output="5000000"
address2=$(cat ../../Wallet/Addr2.addr) 
output2="11000000"
changeAddress="addr_test1vzdp3ue8tlklztd73nkmd3jgnf5rdp0vwsm2zfmxmwu3wvccrv0up"
PREVIEW="--testnet-magic 2"


cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

#with this transaction I am locking value to the contract but I am attaching to a reference script to a different utxo
#the reason is because I want to reference this reference script from a utxo that is not going to be consumed.
# as a side note in my experiments you can consume a utxo containing the reference script but perhaps good to have a designated
# utxo to contain the reference script

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin \
  --tx-out $address+$output \
  --tx-out-inline-datum-file EmptyDatum.json \
  --tx-out $address+$output \
  --tx-out-inline-datum-file datum33.json \
  --tx-out $address+$output \
  --tx-out-inline-datum-file GoodJoker.json \
  --tx-out $address+$output \
  --tx-out-inline-datum-file BadJoker.json \
  --tx-out $address2+$output2 \
  --tx-out-inline-datum-file EmptyDatum.json \
  --tx-out-reference-script-file cDeR.plutus \
  --change-address $changeAddress \
  --protocol-params-file protocol.params \
  --out-file giveV2.unsigned

cardano-cli transaction sign \
    --tx-body-file giveV2.unsigned \
    --signing-key-file ../../Wallet/Addr1.skey \
    $PREVIEW \
    --out-file giveV2.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file giveV2.signed
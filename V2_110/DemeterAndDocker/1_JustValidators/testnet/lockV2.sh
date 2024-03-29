utxoin="508a95074273bd077298a0926c4de425070dc04c029b94113bc9471800d98f06#3"
address=$(cat redeemEqual.addr) 
output="10000000"
address2=$(cat DvR.addr)
output2="8000000"
changeAddress="addr_test1vzdp3ue8tlklztd73nkmd3jgnf5rdp0vwsm2zfmxmwu3wvccrv0up"
PREVIEW="--testnet-magic 2"


cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin \
  --tx-out $address+$output \
  --tx-out-reference-script-file redeemEqual.plutus \
  --tx-out-inline-datum-file value22.json \
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
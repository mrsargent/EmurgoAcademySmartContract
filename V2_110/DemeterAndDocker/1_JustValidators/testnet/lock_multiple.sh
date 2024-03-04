utxoin="05314cecb9e241ea492f942d69ade958587203a2034fe46bb88c62ffac691c28#3"  # the address you are pulling value from 
address=$(cat redeemEqual.addr)  # the address of the contract you are going to be putting value on
output="5000000"  # the value going to the contract
PREVIEW="--testnet-magic 2"
nami="addr_test1vzdp3ue8tlklztd73nkmd3jgnf5rdp0vwsm2zfmxmwu3wvccrv0up" 

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params


cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin \
  --tx-out $address+$output \
  --tx-out-datum-hash-file value22.json \
  --tx-out $address+$output \
  --tx-out-datum-hash-file unit.json \
  --tx-out $address+$output \
  --tx-out-datum-hash-file True.json \
  --change-address $nami \
  --protocol-params-file protocol.params \
  --out-file give.unsigned

cardano-cli transaction sign \
    --tx-body-file give.unsigned \
    --signing-key-file ../../Wallet/Addr1.skey \
    $PREVIEW \
    --out-file give.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file give.signed
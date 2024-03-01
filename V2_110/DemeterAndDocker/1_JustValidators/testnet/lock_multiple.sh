utxoin="bf87f411cd4edc146c196028be48364f30f4e54a78d39ee5caa65e709ba87c7a#1"  # the address you are pulling value from 
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
  --tx-in $utxoin \
  --tx-out $address+$output \
  --tx-out-datum-hash-file unit.json \
  --tx-in $utxoin \
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
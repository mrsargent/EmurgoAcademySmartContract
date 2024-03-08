utxoin1="3c47f5597173953f855836f3fc1a0bd317062e39f8c9ad9ca9c81d88aae8efa6#0"
utxoin2="3c47f5597173953f855836f3fc1a0bd317062e39f8c9ad9ca9c81d88aae8efa6#1"
utxoin3="3c47f5597173953f855836f3fc1a0bd317062e39f8c9ad9ca9c81d88aae8efa6#2"
utxoin4="3c47f5597173953f855836f3fc1a0bd317062e39f8c9ad9ca9c81d88aae8efa6#3"
refscript="2bcded04aff11a3ea7c4ffc678a16b43e88297c750764b63b31a74c5215af454#4"
address="addr_test1vzdp3ue8tlklztd73nkmd3jgnf5rdp0vwsm2zfmxmwu3wvccrv0up"
output="3000000"
collateral="9ee1a1ebcc933d65aaf99593f661c644f001782ef37c744aff3e1b21a453e63c#0"
signerPKH="9c894a0ee5ae77ca1618f5a7d840d9c7c32d92216ffb769faac7091c"
nami="addr_test1vzdp3ue8tlklztd73nkmd3jgnf5rdp0vwsm2zfmxmwu3wvccrv0up" 
PREVIEW="--testnet-magic 2"

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin1 \
  --spending-tx-in-reference $refscript \
  --spending-plutus-script-v2 \
  --spending-reference-tx-in-inline-datum-present \
  --spending-reference-tx-in-redeemer-file EmptyRedeem.json \
  --tx-in $utxoin2 \
  --spending-tx-in-reference $refscript \
  --spending-plutus-script-v2 \
  --spending-reference-tx-in-inline-datum-present \
  --spending-reference-tx-in-redeemer-file redeem33.json \
  --tx-in $utxoin3 \
  --spending-tx-in-reference $refscript \
  --spending-plutus-script-v2 \
  --spending-reference-tx-in-inline-datum-present \
  --spending-reference-tx-in-redeemer-file GoodBatman.json \
  --tx-in $utxoin4 \
  --spending-tx-in-reference $refscript \
  --spending-plutus-script-v2 \
  --spending-reference-tx-in-inline-datum-present \
  --spending-reference-tx-in-redeemer-file BadBatman.json \
  --required-signer-hash $signerPKH \
  --tx-in-collateral $collateral \
  --tx-out $address+$output \
  --change-address $nami \
  --protocol-params-file protocol.params \
  --out-file grabV2.unsigned

cardano-cli transaction sign \
    --tx-body-file grabV2.unsigned \
    --signing-key-file ../../Wallet/Addr2.skey \
    $PREVIEW \
    --out-file grabV2.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file grabV2.signed
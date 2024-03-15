utxoin="248e0421296958b036dcff18f9888580f8a46db791fd05f242b31449b8ddad7b#0"
refscript="3556fa76719b407c6087b1079092c20a79722257005336ed5214a46f5ea2bb13#0"
address="addr_test1vzdp3ue8tlklztd73nkmd3jgnf5rdp0vwsm2zfmxmwu3wvccrv0up" #Addr1
output="15000000"
collateral="9ee1a1ebcc933d65aaf99593f661c644f001782ef37c744aff3e1b21a453e63c#0" #colllateral from Addr2
signerPKH="9c894a0ee5ae77ca1618f5a7d840d9c7c32d92216ffb769faac7091c"
nami="addr_test1vzdp3ue8tlklztd73nkmd3jgnf5rdp0vwsm2zfmxmwu3wvccrv0up" 
signerOfSmartContract="9a18f3275fedf12dbe8cedb6c6489a683685ec7436a12766dbb91733" #pkh of Addr1
PREVIEW="--testnet-magic 2"

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin \
  --spending-tx-in-reference $refscript \
  --spending-plutus-script-v2 \
  --spending-reference-tx-in-inline-datum-present \
  --spending-reference-tx-in-redeemer-file redeemTrue.json \
  --required-signer-hash $signerPKH \
  --required-signer-hash $signerOfSmartContract \
  --tx-in-collateral $collateral \
  --tx-out $address+$output \
  --change-address $nami \
  --invalid-hereafter 43721240 \
  --protocol-params-file protocol.params \
  --out-file handsOn3grab.unsigned

cardano-cli transaction sign \
    --tx-body-file handsOn3grab.unsigned \
    --signing-key-file ../../Wallet/Addr2.skey \
    --signing-key-file ../../Wallet/Addr1.skey \
    $PREVIEW \
    --out-file handsOn3grab.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file handsOn3grab.signed
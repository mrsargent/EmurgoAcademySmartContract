utxoin1="51620d2d254b0f6ff7a7422adda80b12fc1588b2308a8a4126644ce1749ba57d#0"
utxoin2="51620d2d254b0f6ff7a7422adda80b12fc1588b2308a8a4126644ce1749ba57d#1"
utxoin3="51620d2d254b0f6ff7a7422adda80b12fc1588b2308a8a4126644ce1749ba57d#2"
utxoin4="51620d2d254b0f6ff7a7422adda80b12fc1588b2308a8a4126644ce1749ba57d#3"
refscript="51620d2d254b0f6ff7a7422adda80b12fc1588b2308a8a4126644ce1749ba57d#3"
address="addr_test1vzdp3ue8tlklztd73nkmd3jgnf5rdp0vwsm2zfmxmwu3wvccrv0up"
output="4000000"
collateral="9ee1a1ebcc933d65aaf99593f661c644f001782ef37c744aff3e1b21a453e63c#0"
signerPKH="9c894a0ee5ae77ca1618f5a7d840d9c7c32d92216ffb769faac7091c"
nami="addr_test1vzdp3ue8tlklztd73nkmd3jgnf5rdp0vwsm2zfmxmwu3wvccrv0up" 
PREVIEW="--testnet-magic 2"

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin3 \
  --spending-tx-in-reference $refscript \
  --spending-plutus-script-v2 \
  --spending-reference-tx-in-inline-datum-present \
  --spending-reference-tx-in-redeemer-file GoodJoker.json \
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
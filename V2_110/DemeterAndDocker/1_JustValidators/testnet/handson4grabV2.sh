utxoin="27aa94afe3fe3c85cbba77fc9addf082243ca03e97388578b330233746e87b85#0"
refscript="27aa94afe3fe3c85cbba77fc9addf082243ca03e97388578b330233746e87b85#0"
address="addr_test1vzdp3ue8tlklztd73nkmd3jgnf5rdp0vwsm2zfmxmwu3wvccrv0up" #Addr1
output="25000000"
collateral="9ee1a1ebcc933d65aaf99593f661c644f001782ef37c744aff3e1b21a453e63c#0" #colllateral from Addr2
signerPKH="9c894a0ee5ae77ca1618f5a7d840d9c7c32d92216ffb769faac7091c"
nami="addr_test1vzdp3ue8tlklztd73nkmd3jgnf5rdp0vwsm2zfmxmwu3wvccrv0up" 
PREVIEW="--testnet-magic 2"
addr1pkh="9a18f3275fedf12dbe8cedb6c6489a683685ec7436a12766dbb91733"
addr2pkh="9c894a0ee5ae77ca1618f5a7d840d9c7c32d92216ffb769faac7091c"

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin \
  --spending-tx-in-reference $refscript \
  --spending-plutus-script-v2 \
  --spending-reference-tx-in-inline-datum-present \
  --spending-reference-tx-in-redeemer-file redeemTrue.json \
  --required-signer-hash $addr1pkh \
  --required-signer-hash $addr2pkh \
  --tx-in-collateral $collateral \
  --tx-out $address+$output \
  --change-address $nami \
  --protocol-params-file protocol.params \
  --out-file handsOn4grab.unsigned

cardano-cli transaction sign \
    --tx-body-file handsOn4grab.unsigned \
    --signing-key-file ../../Wallet/Addr1.skey \
    --signing-key-file ../../Wallet/Addr2.skey \
    $PREVIEW \
    --out-file handsOn4grab.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file handsOn4grab.signed
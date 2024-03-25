utxoin="07cdcebce1c1918f8e28347fe5351ddb32743dc6b3f5ddd28a6064ed09b923bf#4"
output="40000000"
collateral="9ee1a1ebcc933d65aaf99593f661c644f001782ef37c744aff3e1b21a453e63c#0" # addr2 
signerPKH="9c894a0ee5ae77ca1618f5a7d840d9c7c32d92216ffb769faac7091c"  #pkh of Addr2
nami="addr_test1qpc6mrwu9cucrq4w6y69qchflvypq76a47ylvjvm2wph4szeq579yu2z8s4m4tn0a9g4gfce50p25afc24knsf6pj96sz35wnt" 
PREVIEW="--testnet-magic 2"

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin \
  --tx-in-script-file mathBounty.plutus \
  --tx-in-datum-file bountyConditions.json \
  --tx-in-redeemer-file redeem13.json \
  --required-signer-hash $signerPKH \
  --tx-in-collateral $collateral \
  --tx-out $Addr1+$output \
  --change-address "addr_test1vzdp3ue8tlklztd73nkmd3jgnf5rdp0vwsm2zfmxmwu3wvccrv0up" \
  --protocol-params-file protocol.params \
  --invalid-hereafter 44661702 \
  --out-file mathbounty.unsigned 

cardano-cli transaction sign \
    --tx-body-file mathbounty.unsigned \
    --signing-key-file ../../Wallet/Addr2.skey \
    $PREVIEW \
    --out-file mathbounty.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file mathbounty.signed
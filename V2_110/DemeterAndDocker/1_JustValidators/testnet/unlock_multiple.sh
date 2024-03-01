utxoin1="1b93cf9117648ddac56b3f50afa26b3d0fcbee81f2a3419381c7619dd393213e#2" #this is the utxo of the contract 
utxoin2="bf87f411cd4edc146c196028be48364f30f4e54a78d39ee5caa65e709ba87c7a#0" #this is the utxo of the contract 
address=$(cat ../../Wallet/Addr2.addr)   #this is the address where the contract will send funds to
output="3000000" #amount of ada sent to the address.  Remember you need a minimum of 1A left over for the transaction to complete
collateral="9ee1a1ebcc933d65aaf99593f661c644f001782ef37c744aff3e1b21a453e63c#0"
signerPKH="9c894a0ee5ae77ca1618f5a7d840d9c7c32d92216ffb769faac7091c"    #$(cat ialice.pkh)
nami="addr_test1vzdp3ue8tlklztd73nkmd3jgnf5rdp0vwsm2zfmxmwu3wvccrv0up" 
PREVIEW="--testnet-magic 2"

cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

#required-signer-hash is for the collateral. the signing-key-file is for the collateral as well.
cardano-cli transaction build \
  --babbage-era \
  $PREVIEW \
  --tx-in $utxoin1 \
  --tx-in-script-file redeemEqual.plutus \
  --tx-in-datum-file True.json \
  --tx-in-redeemer-file True.json \
  --tx-in $utxoin2 \
  --tx-in-script-file redeemEqual.plutus \
  --tx-in-datum-file unit.json \
  --tx-in-redeemer-file value11.json \
  --required-signer-hash $signerPKH \
  --tx-in-collateral $collateral \
  --tx-out $address+$output \
  --change-address $nami \
  --protocol-params-file protocol.params \
  --out-file grab.unsigned

cardano-cli transaction sign \
    --tx-body-file grab.unsigned \
    --signing-key-file ../../Wallet/Addr2.skey \
    $PREVIEW \
    --out-file grab.signed

 cardano-cli transaction submit \
    $PREVIEW \
    --tx-file grab.signed
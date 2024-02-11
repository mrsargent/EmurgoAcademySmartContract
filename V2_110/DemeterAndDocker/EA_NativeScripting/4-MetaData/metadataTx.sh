cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  --testnet-magic 2 \
  --tx-in "518ced66d03c090eac406b39b6d765d5b223d23d0b0856be9bee73a5d1f878b0#0" \
  --change-address "addr_test1qqd2cd7rnup5zzylt34na9srfswhe6pvqk6c03zqs6ulklkm8f39nn3f9pdmr0yxeakqnnj90drjjx82vrnpjpw79lsq2caqqf" \
  --metadata-json-file testFile.json \
  --protocol-params-file protocol.params \
  --out-file metadataTx.unsigned

cardano-cli transaction sign \
  --tx-body-file metadataTx.unsigned \
  --signing-key-file ../1-SimplePayment/batch107.skey \
  --testnet-magic 2 \
  --out-file metadataTx.signed

 cardano-cli transaction submit \
  --testnet-magic 2 \
  --tx-file metadataTx.signed
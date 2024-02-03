cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  --testnet-magic 2 \
  --tx-in "518ced66d03c090eac406b39b6d765d5b223d23d0b0856be9bee73a5d1f878b0#5" \
  --tx-in "7f447e5a0174ffdbea2f69a0e71d54365094d3b67616e76520a15ab1b49aeb1d#0" \
  --tx-out "addr_test1qqd2cd7rnup5zzylt34na9srfswhe6pvqk6c03zqs6ulklkm8f39nn3f9pdmr0yxeakqnnj90drjjx82vrnpjpw79lsq2caqqf 10000000" \
  --tx-out "addr_test1qpc6mrwu9cucrq4w6y69qchflvypq76a47ylvjvm2wph4szeq579yu2z8s4m4tn0a9g4gfce50p25afc24knsf6pj96sz35wnt 90000000" \
  --change-address "addr_test1vr0feecvsunt3zf68jzzc6zx6d24vhuxuu9drwjnx078jsg9rcjms" \
  --protocol-params-file protocol.params \
  --out-file payment.unsigned


cardano-cli transaction sign \
  --tx-body-file payment.unsigned \
  --signing-key-file ../1-SimplePayment/batch107.skey \
  --testnet-magic 2 \
  --out-file payment.signed

 cardano-cli transaction submit \
  --testnet-magic 2 \
  --tx-file payment.signed
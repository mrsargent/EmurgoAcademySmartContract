cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  --testnet-magic 2 \
  --tx-in "dfbe511e40c8f42d024b421611c4314f3d9af34dbcabc8fb5dade53d91ed6d8a#5" \
  --tx-out "addr_test1qqd2cd7rnup5zzylt34na9srfswhe6pvqk6c03zqs6ulklkm8f39nn3f9pdmr0yxeakqnnj90drjjx82vrnpjpw79lsq2caqqf 100000000" \
  --tx-out "addr_test1qqd2cd7rnup5zzylt34na9srfswhe6pvqk6c03zqs6ulklkm8f39nn3f9pdmr0yxeakqnnj90drjjx82vrnpjpw79lsq2caqqf 100000000" \
  --tx-out "addr_test1qpc6mrwu9cucrq4w6y69qchflvypq76a47ylvjvm2wph4szeq579yu2z8s4m4tn0a9g4gfce50p25afc24knsf6pj96sz35wnt 50000000" \
  --tx-out "addr_test1qpc6mrwu9cucrq4w6y69qchflvypq76a47ylvjvm2wph4szeq579yu2z8s4m4tn0a9g4gfce50p25afc24knsf6pj96sz35wnt 50000000" \
  --tx-out "addr_test1qpc6mrwu9cucrq4w6y69qchflvypq76a47ylvjvm2wph4szeq579yu2z8s4m4tn0a9g4gfce50p25afc24knsf6pj96sz35wnt 50000000" \
  --change-address "addr_test1qqd2cd7rnup5zzylt34na9srfswhe6pvqk6c03zqs6ulklkm8f39nn3f9pdmr0yxeakqnnj90drjjx82vrnpjpw79lsq2caqqf" \
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
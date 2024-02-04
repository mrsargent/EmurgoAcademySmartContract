cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  --testnet-magic 2 \
  --tx-in "7f447e5a0174ffdbea2f69a0e71d54365094d3b67616e76520a15ab1b49aeb1d#1" \
  --tx-in "9d10f7d50777c69a7764ee56edcc62b25935ea2709e79db82700a95903a9a692#2" \
  --tx-out "addr_test1qpc6mrwu9cucrq4w6y69qchflvypq76a47ylvjvm2wph4szeq579yu2z8s4m4tn0a9g4gfce50p25afc24knsf6pj96sz35wnt 17000000" \
  --change-address "addr_test1vqvgtczpn403t2pg55kgrdm0yhc9vcq0kaekm3z4cdpx8cg3ye3cm" \
  --protocol-params-file protocol.params \
  --out-file multisig.unsigned

cardano-cli transaction sign \
    --tx-body-file multisig.unsigned \
    --signing-key-file ../1-SimplePayment/batch107.skey \
    --signing-key-file ../1-SimplePayment/en107.skey \
    --testnet-magic 2 \
    --out-file multisig.signed

 cardano-cli transaction submit \
    --testnet-magic 2 \
    --tx-file multisig.signed

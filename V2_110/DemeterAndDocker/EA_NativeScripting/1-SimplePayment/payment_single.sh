cardano-cli query protocol-parameters --testnet-magic 2 --out-file protocol.params

cardano-cli transaction build \
  --babbage-era \
  --testnet-magic 2 \
  --tx-in "4196f74043dbd8e70ba25860a2a1178867987a231c68c24e920c2cf6cb6c46d6#1" \
  --tx-out "addr_test1vzdp3ue8tlklztd73nkmd3jgnf5rdp0vwsm2zfmxmwu3wvccrv0up 9705658400" \
  --change-address "addr_test1vzwgjjswukh80jskrr660kzqm8ruxtvjy9hlka5l4trsj8qv5yfy0" \
  --protocol-params-file protocol.params \
  --out-file payment.unsigned


cardano-cli transaction sign \
  --tx-body-file payment.unsigned \
  --signing-key-file ../../Wallet/Addr2.skey \
  --testnet-magic 2 \
  --out-file payment.signed

 cardano-cli transaction submit \
  --testnet-magic 2 \
  --tx-file payment.signed
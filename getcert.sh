 i=1
 while [ $i -lt 25 ]
 do 

  ARQ=peticionamento.prt${i}.mpt.mp.br
  openssl s_client -showcerts -connect ${ARQ}:443 > ${ARQ} < /dev/null
  openssl x509 -outform PEM < ${ARQ} > ${ARQ}.cer 
  keytool -importcert -file ${ARQ}.cer -alias $ARQ -storepass changeit -noprompt -keystore server.keystore
  rm -f $ARQ
  i=$((i+1))
 done
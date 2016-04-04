#!/bin/bash
FILE=$1
FILE_SAIDA=/tmp/p.${RANDOM}
base64 -d $FILE > $FILE_SAIDA; openssl asn1parse -i -inform DER -in $FILE_SAIDA; rm -f $FILE_SAIDA  

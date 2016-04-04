#!/bin/bash
##########################################################################
# Title      :  Verifica atualizacao de Certificados 
# Author     :  Luciano Vilela Dourado <luciano.dourado@pgt.mpt.gov.br>
# Date       :  2009-05-05
# Requires   :  wget 
##########################################################################
# Description
#
##########################################################################
PN=`basename $0`
VER='1.0'
REG_INSTALACAO=
WGET="wget  -UMozilla/5.0 "
TMP="/var/tmp/acs"
function LOG() {
        echo `date "+%d/%m/%Y %H:%M:%S"` $@
}

function inicializa(){

  if [[  -d $TMP ]]
  then
    rm -rf $TMP
  fi

  mkdir -p $TMP

}

function baixaArquivo(){
  SERVIDOR_ICPBRASIL="http://acraiz.icpbrasil.gov.br/credenciadas/CertificadosAC-ICP-Brasil"
  ARQUIVO_ICPBRASIL="ACcompactado.zip"


  $WGET "${SERVIDOR_ICPBRASIL}/${ARQUIVO_ICPBRASIL}"

  unzip $ARQUIVO_ICPBRASIL

  rm -f $ARQUIVO_ICPBRASIL
}

function main(){
  cd $TMP


  for i in ./*.crt
  do
     keytool  -printcert -file $i  | grep -i "proprietário\|emissor"|sed 's/.*CN=\(\[\\w\\s\]+\),.*/\\1/'
  done
}


main




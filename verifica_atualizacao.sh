#!/bin/bash 
##########################################################################
# Title      :  Atualiza MPTDigital com a versao do SVN
# Author     :  Luciano Vilela Dourado <luciano.dourado@pgt.mpt.gov.br>
# Date       :  2009-03-31
# Requires   :  
# SCCS-Id.   :  @(#) cpdir      1.4 06/03/15
##########################################################################
# Description
#
##########################################################################
PN=`basename $0`
VER='1.0'
REG_INSTALACAO=
#SERVIDOR=http://mptdigital-piloto.pgt.mpt.gov.br/mptdigital-repo
SERVIDOR=http://10.0.5.190/atualizacao
REPOSITORIO=http://homologacao.pgt.mpt.gov.br/svn
PASTA_SIS=/var/www/MPTDigital

ARQUIVO_CONTROLE=${PASTA_SIS}/conf/controle_atualizacao.ctl
ARQUIVO_CONFIG=/etc/mptdigital.conf


WGET="wget  -UMozilla/5.0 --connect-timeout=3 -t2 "

MODULOS=("AgendaCorporativa" "BDMysql" "CODIN" "ECOI" "Intranet" "RecursosHumanos")
DIR=("agendaCorporativa" "bancoDocumento" "codin" "coi" "intranet" "recursosHumanos")

function LOG(){
        echo `date "+%d/%m/%Y %H:%M:%S"` $@
}

function usage () {
    echo >&2 "$PN - Instalador do MPTDigital versao, $VER
usage: $PN [-h]
        -h:  imprime essa mensagem
    "
    exit 1
}

if [ -f $ARQUIVO_CONFIG ]
then
	. $ARQUIVO_CONFIG
else
	LOG "Nao foi possivel encontrar o arquivo $ARQUIVO_CONFIG"
	exit 1
fi

if [ ! -f "$ARQUIVO_CONTROLE"  ]
then
	touch $ARQUIVO_CONTROLE
fi

##
# Tratamento de paramentos de entrada
##
while [ $# -gt 0 ]
do
    case "$1" in
        -h)     usage;;
        -*)     usage;;
        *)      break;;                 # First file name
    esac
    shift
done


#FLAG que determina se algum pacote foi atualizado
ATUALIZADO=0

#para cada pacote, verifica qual a versao instalada
#buscar no 
i=0

LOG "Inicio do processo de atualizacao"

while [ $i != ${#MODULOS[@]} ]
do
	LOG Verificando atualizacoes para : ${MODULOS[$i]}
	VERSAO=`rpm -qa | grep ${MODULOS[$i]} | cut -d'-' -f3`
	SUBVERSAO=1
	EXECUTA=1
	while [ $EXECUTA -gt 0 ]
	do        

		NOME_ARQUIVO=${MODULOS[$i]}.${VERSAO}-${SUBVERSAO}
                grep $NOME_ARQUIVO $ARQUIVO_CONTROLE > /dev/null
                JA_EXECUTADO=$?
                if [ $JA_EXECUTADO -ne 0 ]
                then

			$WGET -o /dev/null "${SERVIDOR}/${DIR[$i]}/${VERSAO}/${NOME_ARQUIVO}"
			if [ $? -ne 0 ] 
			then
				LOG "Ocorreu um erro ao conectar em '${SERVIDOR}'"
				LOG " Verifique as configuracoes de proxy "
			fi			

			if [ -f $NOME_ARQUIVO ]
			then
	                        
				for LINHA in `cat $NOME_ARQUIVO`
				do
					#quando a linha comecar com trunk descarta somente um diretorio
					#senao descarta dois.
					x=$(echo $LINHA | perl -e "
						while(<>){

							if(/^\/trunk/){
								s/^(\/[\w\d\.]*\/)/\//;
								print \$_;
							}
							else{
								s/^(\/[\w\d\.]*\/[\w\d\.]*\/)/\//;
								print \$_;
							}
						}

					")
					
					ORIGEM=${REPOSITORIO}/${DIR[$i]}$LINHA
					DESTINO=${PASTA_SIS}/${DIR[$i]}$x	
					LOG Aplicando patch $ORIGEM $DESTINO
					$WGET -o /dev/null -O $DESTINO $ORIGEM
					if [ $? -ne 0 ] 
					then
						LOG "Ocorreu um erro ao baixar 	'$ORIGEM'"
					fi			
				done
				ATUALIZADO=1
				echo $NOME_ARQUIVO executado em : `date "+%d/%m/%y %H:%M:%S"`  >> $ARQUIVO_CONTROLE

				rm -f $NOME_ARQUIVO
			else
				EXECUTA=-1

	                fi
	     	fi
		let SUBVERSAO=$SUBVERSAO+1		
	done
	let i=$i+1
done
if [ $ATUALIZADO -eq 1 ]
then
	${PASTA_SIS}/conf/configura_mptdigital.sh
fi
LOG "Fim do processo de atualizacao"

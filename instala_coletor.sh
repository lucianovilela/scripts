#!/bin/bash
##########################################################################
# Title      :  Instala Coletor
# Author     :  Luciano Vilela Dourado <luciano.dourado@pgt.mpt.gov.br>
# Date       :  2009-05-05
# Requires   :  wget rpm
##########################################################################
# Description
#
##########################################################################
PN=`basename $0`
VER='1.0'
REG_INSTALACAO=
SERVIDOR=http://homologacao.pgt.mpt.gov.br/svn/documentacao/trunk/Coletor-Client
ARQ_COLETOR=Coletor-Client-1.0.one-jar.jar
VERSAO_JAVA=1.5.0_18
VERSAO_ARQUIVO_JAVA=1_5_0_18
ARQ_JAVA=jre-${VERSAO_ARQUIVO_JAVA}-linux-i586.rpm

DIR_COLETOR=/var/www/MPTDigital/coletor
#WGET="wget -q "

WGET="wget  -UMozilla/5.0 "
#REPOINI=http://homologacao.pgt.mpt.gov.br/svn/documentacao/trunk/GeracaoPacote/conf
#MPTDIGITAL_REPO=MPTDigital-Repo-1.0-0.0.2.noarch.rpm


function configuraEnv() {
        LOG "Configurando o ambiente Java"
        grep "#Configuracao Java" /etc/profile > /dev/null
        if [ "$?" -eq "1" ]
        then
                cat << EOF >> /etc/profile


#Configuracao Java
JAVA_HOME=/usr/java/jre${VERSAO_JAVA}
PATH=${JAVA_HOME}/bin:\$PATH

export JAVA_HOME PATH



EOF
        fi

}

function configuraCron() {
        CRON=`$WGET ${SERVIDOR}/crontab.txt -O - | grep $REG_INSTALACAO | cut -d";" -f2`
        if [ ! -z "$CRON" ]
        then

                crontab -l > crontab.temp
                grep  ${ARQ_COLETOR} crontab.temp > /dev/null
                if [ "$?" -eq "1" ]
                then
                        LOG "Configurando a crontab"
                        DATACRON=`date "+%d/%m/%Y %H:%M:%S"`
                        cat << EOF >> crontab.temp
#
#Configuracao do Coletor em $DATACRON
#
$CRON /usr/java/jre${VERSAO_JAVA}/bin/java -client  -jar $DIR_COLETOR/${ARQ_COLETOR}

EOF
                        crontab crontab.temp
                fi 
                unset DATACRON
                rm -f crontab.temp
        fi
}

function instalaJava() {
        LOG "Instalando Java"
        LOG "Baixando ${SERVIDOR}/${ARQ_JAVA}"
        $WGET ${SERVIDOR}/${ARQ_JAVA}
        if [ "$?" -eq "0" ]
        then
                rpm -ivh $ARQ_JAVA
        else
                LOG "Ocorreu um erro realizar a instalacao do Java"
        fi
        rm -f $ARQ_JAVA

}


function instalaColetor() {
        LOG "Instalando coletor"
        if [ ! -d $DIR_COLETOR ] 
        then
                LOG "Criando diretorio $DIR_COLETOR"
                mkdir $DIR_COLETOR
        fi
        DIR_ORIGEM=$PWD
        cd $DIR_COLETOR
		if [ -f "$DIR_COLETOR/${ARQ_COLETOR}" ]
		then
			DATA_LOG=`date "+%Y%m%d_%H%M%S"`
			LOG "Renomeando ${ARQ_COLETOR} para ${ARQ_COLETOR}_${DATA_LOG}"
			mv "$DIR_COLETOR/${ARQ_COLETOR}" "$DIR_COLETOR/${ARQ_COLETOR}_${DATA_LOG}"
		fi
        LOG "Baixando do Coletor do servidor ${SERVIDOR}/${ARQ_COLETOR}"
        LOG $WGET ${SERVIDOR}/${ARQ_COLETOR}
        $WGET ${SERVIDOR}/${ARQ_COLETOR}
        if [ -f /etc/mptdigital.conf ] 
        then
                LOG "Carregando configuracoes regionais de /etc/mtpdigital.conf"
                . /etc/mptdigital.conf

                if [ ! -d /var/www/MPTDigital/bancoDocumento/documentos/docs ] 
                then
                        LOG "ERROR ----  Diretorio de documento do Banco de documento nao foi encontrado"
                fi 
                LOG "Configurando o coletor com as informacoes da Regional"
                cat << EOF | /usr/java/jre${VERSAO_JAVA}/bin/java -client -jar $DIR_COLETOR/${ARQ_COLETOR}
s
$NUMREG
com.mysql.jdbc.Driver
$MYUSER
$MYPASS
jdbc:mysql://localhost/${DBNAME}
/var/www/MPTDigital/bancoDocumento/documentos/docs
S
n
EOF
        fi
        cd $DIR_ORIGEM

}

function usage() {
    echo >&2 "$PN - Instalador do Coletor versao, $VER
usage: $PN [-i regional] [-cmd comando] [-h]
        -cmd comando
                usage
                configuraEnv
                configuraCron
                instalaJava
                instalaColetor
                install ( Faz o processamento completo de instalacao )
                clean ( Desistala todo os pacotes do Coletor - Em desenvolvimento)
        -h:  imprime essa mensagem
    "
    exit 1
}


function install() {
        instalaJava
        configuraEnv
        instalaColetor
        configuraCron
}





function LOG() {
        echo `date "+%d/%m/%Y %H:%M:%S"` $@
}

##
# Tratamento de paramentos de entrada
##
while [ $# -gt 0 ]
do
    case "$1" in
        -i)     shift; REG_INSTALACAO=$1;;
        -cmd)  shift; COMANDO=$1;;
        --)     shift; break;;
        -h)     usage;;
        -*)     usage;;
        *)      break;;                 # First file name
    esac
    shift
done



if [ -z "$REG_INSTALACAO" ]
then
        usage
        exit 1
fi

if [ ! -z "$COMANDO" ]
then
        $COMANDO
fi




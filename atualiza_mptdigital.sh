#!/bin/bash 
##################################################
#  Atualiza MPTDigital
#  Executa a atualizacao do MPTDigital a partir do
#  repositorio
# 
#
#  alteracao 29/01/2009
#  Inclusao do loop na execucao do yum -y update
#  Luciano Vilela
##################################################
yum clean all

SUCESSO=0
TENTATIVAS=100
while [[ $SUCESSO -lt $TENTATIVAS ]] 
do
	echo Executado update MPTDigital
	yum -y update MPTDigital*
 	if [ $? -eq 0 ]
	then
		SUCESSO=$TENTATIVAS
	else
		SUCESSO=$((SUCESSO+1))
	fi	
done
/var/www/MPTDigital/conf/configura_mptdigital.sh

if [[ -s /var/www/MPTDigital/conf/mensagem.txt ]]
then
        echo -e "\033[34m\033[41m  Atencao Administrador do Sistema  \033[0m";
        echo -e "\033[34m\033[41m  Existe uma mensagem de configuracao  \033[0m";

        MSG=`cat /var/www/MPTDigital/conf/mensagem.txt`
        echo -e $MSG

        echo -e "\033[34m\033[41m  Fim da mensagem  \033[0m";



fi
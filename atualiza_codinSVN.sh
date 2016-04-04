#!/bin/bash

if [ ! -d /var/www/MPTDigital/codin/.svn ]
then {
  echo "Criando repositorio local (checkout no trunk)"
  rm -rf /var/www/MPTDigital/codin/*
  svn checkout http://homologacao.pgt.mpt.gov.br/svn/codin/trunk /var/www/MPTDigital/codin
} fi
echo "Atualizando repositorio local (update em branch)"
svn switch http://homologacao.pgt.mpt.gov.br/svn/codin/branches/v1.1 /var/www/MPTDigital/codin

/var/www/MPTDigital/conf/configura_mptdigital.sh


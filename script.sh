#!/bin/sh
LOG=/var/log/jperf-2.0.0/bin/log.txt 
JPERF=/usr/local/bin/iperf
SERVIDOR_JPERF=192.168.254.1
echo "    ********************************"
echo "    *** TESTE DA  INFRAESTRUTURA ***"
echo "    *** sigsuporte@cds.eb.mil.br ***"
echo "    ********************************"
echo "==================================================================">>$LOG
echo "1) Host:" >> $LOG
echo `hostname`>> $LOG
echo "2) Data:">>$LOG
echo `date "+%d/%m/%y"` >> $LOG
echo "3) Hora:">>$LOG
echo `date "+%H:%M:%S"` >>$LOG
echo "4) Resultado do Teste:">>$LOG
$JPERF -c $SERVIDOR_JPERF -P 1 -i 1 -p 5001 -f m -t 5  >> $LOG
echo . >>$LOG
echo    "Para visualizar o resultado abra o arquivo $LOG"


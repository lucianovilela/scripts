#!/usr/bin/ksh
crontab -l | grep -e "java -client.*-Xms.*"  > /dev/null
if [ "$?" -eq "1" ]
then
	crontab -l | sed '/java -client/ s/java -client/java -client -Xms256m -Xmx512m/' | crontab 
fi
echo "Cron configurado com sucesso"

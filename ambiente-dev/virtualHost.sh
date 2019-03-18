#!/bin/bash
#

sudo apt-get -y install apache2 php5-mysql php5 libapache2-mod-php5 php5-mcrypt

PATH_CONF=/etc/apache2/sites-available/
ARQU_DEF=000-default.conf

#ARQUIVO=desenvolvimento.conf

arquivos=("desenvolvimento" "homologacao" "treinamento")


for arquivo in ${arquivos[*]}
do
	if [ -e "$PATH_CONF$arquivo.conf" ]; then

		echo -e "Desabilitando virtualhost $arquivo ...\n"
		sleep 1s
		sudo a2dissite "$arquivo.conf"

		echo -e "Reiniciando Apache\n"
		sleep 1s
		sudo service apache2 restart

		echo -e "O Arquivo $arquivo Existe e será deletado...\n"
		sleep 1s
		sudo rm "$PATH_CONF$arquivo.conf"
	fi

	echo -e "Copiando arquivo virtualhost default para virtualhost $arquivo.conf ...\n"
	sleep 1s
	sudo cp "$PATH_CONF$ARQU_DEF" "$PATH_CONF$arquivo.conf"

	echo -e "Substituindo caminho da pasta padrão...\n"
	sleep 1s

	sudo sed -i "s/\/var\/www\/html/\/var\/www\/html\/$arquivo/g" "$PATH_CONF$arquivo.conf"
	sudo sed -i "s/#ServerName www.example.com/ServerName $arquivo/g" "$PATH_CONF$arquivo.conf"


	echo -e "Habilitando virtualhost $arquivo.conf ...\n"
	sleep 1s
	sudo a2ensite "$arquivo.conf"
done
echo -e "Desabilitando virtualhost default...\n"
sleep 1s
sudo a2dissite $ARQU_DEF
echo -e "Reiniciando Apache\n"
sleep 1s
sudo service apache2 restart



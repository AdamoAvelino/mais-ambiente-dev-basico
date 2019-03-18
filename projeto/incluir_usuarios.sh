#!/bin/bash
#echo linha | sed 's/\([a-z]*\)\([=]\)\([.]*\)/\3/'

for i in usuarios/*
do
	while read LINHA; do
	  ATRIBUTO=$(echo $LINHA | sed 's/^\([^=]*\).*/\1/')
	  VALOR=$(echo $LINHA | sed 's/\([a-z]*\)\([=]\)\([.]*\)/\3/')
	 echo "$VALOR - $ATRIBUTO"
	  if [[ $ATRIBUTO = 'nome' ]]
	  then
	    NOME="$VALOR"
	  elif [[ $ATRIBUTO = 'senha' ]]
	  then
	    SENHA="$VALOR"
	  elif [[ $ATRIBUTO = 'chave' ]]
	  then
	    CHAVE="$VALOR"
	  else
	    GRUPO="$VALOR"
	  fi

	done < "$i"
	sudo useradd -m -p $(perl -e 'print crypt('$SENHA',"mais")') "$NOME"
	sudo mkdir /home/$NOME/.ssh
	sudo touch /home/$NOME/.ssh/authorized_keys
	sudo chmod 777 /home/$NOME/.ssh/authorized_keys
	sudo echo $CHAVE >> /home/$NOME/.ssh/authorized_keys
	sudo chmod 664 /home/$NOME/.ssh/authorized_keys
	sudo chown -R $NOME:$NOME /home/$NOME/.ssh
	sudo addgroup "$NOME" desenvolvedor

	if [[ $GRUPO = 'deployer'  ]]
	then
	  sudo addgroup "$NOME" deployer
	fi

done





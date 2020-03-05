#!/bin/sh
# Após execuitar este processo, não esquecer de gerar um keygen para cada usuario criado
# Além das chaves ssh padrão, também devemos criar um chave ssh especifica para deployer
# exemplo.:ssh-keygen -f ~/.ssh/deployerkey
#--------------------------------------------------------------------------------------
echo "Criação dos diretórios web que receberão os checkout dos repositórios git"
sudo mkdir /var/www/html/desenvolvimento
sudo mkdir /var/www/html/homologacao
sudo mkdir /var/www/html/treinamento

#----------------------------------------------------------------------------------------
echo "Configuração do acesso aos ambientes web" 
sudo chmod -R 666 /etc/apache2/sites-available/000-default.conf
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.backup
echo "<Directory /var/www/html>" >> /etc/apache2/sites-available/000-default.conf
echo "Require all granted" >> /etc/apache2/sites-available/000-default.conf
echo "Options -Indexes" >> /etc/apache2/sites-available/000-default.conf
echo "AllowOverride All" >> /etc/apache2/sites-available/000-default.conf
echo "</Directory>" >> /etc/apache2/sites-available/000-default.conf
sudo chmod -R 644 /etc/apache2/sites-available/000-default.conf
sudo service apache2 restart


#----------------------------------------------------------------------------------------
echo "Criação dos usuarios da estrutura do sistema de deploy"
sudo useradd -m -p $(perl -e 'print crypt("secretgit", "git")') git
sudo useradd -m -p $(perl -e 'print crypt("secretdesenvolvedor", "git")') desenvolvedor
sudo useradd -m -p $(perl -e 'print crypt("secretdeployer", "git")') deployer

#-------------------------------------------------------------------------------------
echo "Criação dos repositórios para cada ambiente"
sudo git init --bare --shared=group /home/git/desenvolvimento
sudo chown -R git:desenvolvedor /home/git/desenvolvimento

sudo git init --bare --shared=group /home/git/homologacao
sudo chown -R git:deployer /home/git/homologacao

sudo git init --bare --shared=group /home/git/treinamento
sudo chown -R git:deployer /home/git/treinamento

#----------------------------------------------------------------------------------------
echo "Criação da automação do de checkout para os diretórios web para cada ambiente"
sudo touch /home/git/desenvolvimento/hooks/post-receive
sudo chmod 777 /home/git/desenvolvimento/hooks/post-receive
sudo echo "#!/bin/sh" >> /home/git/desenvolvimento/hooks/post-receive
sudo echo "GIT_WORK_TREE=/var/www/html/desenvolvimento git checkout -f" >> /home/git/desenvolvimento/hooks/post-receive


sudo touch /home/git/homologacao/hooks/post-receive
sudo chmod 777 /home/git/homologacao/hooks/post-receive
sudo echo "#!/bin/sh" >> /home/git/homologacao/hooks/post-receive
sudo echo "GIT_WORK_TREE=/var/www/html/homologacao git checkout -f" >> /home/git/homologacao/hooks/post-receive

sudo touch /home/git/treinamento/hooks/post-receive
sudo chmod 777 /home/git/treinamento/hooks/post-receive
sudo echo "#!/bin/sh" >> /home/git/treinamento/hooks/post-receive
sudo echo "GIT_WORK_TREE=/var/www/html/treinamento git checkout -f" >> /home/git/treinamento/hooks/post-receive

#-----------------------------------------------------------------------------------------
echo "Reescrevendo o dono e as permisões de execução do arquivo de automação de checkout"
sudo chown git:deployer /home/git/treinamento/hooks/post-receive
sudo chmod 755 /home/git/treinamento/hooks/post-receive

sudo chown git:deployer /home/git/homologacao/hooks/post-receive
sudo chmod 755 /home/git/homologacao/hooks/post-receive

sudo chown git:desenvolvedor /home/git/desenvolvimento/hooks/post-receive
sudo chmod 755 /home/git/desenvolvimento/hooks/post-receive

#--------------------------------------------------------------------------------------
echo "Configurando proprietários e grupos para os diretórios web"
sudo chown -R www-data:desenvolvedor /var/www/html/desenvolvimento
sudo chown -R www-data:deployer /var/www/html/homologacao
sudo chown -R www-data:deployer /var/www/html/treinamento

sudo chmod -R 661 /var/www/html/desenvolvimento
sudo chmod -R 661 /var/www/html/homologacao
sudo chmod -R 661 /var/www/html/treinamento

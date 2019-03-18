Maquina desenvolvimento - Sistema de Deployer

	Configuração básica:
	OS: Linux Ubuntu 14.04
	Servidor Web: Apache 2.2.4
	Liguagem Script: PHP 5.5.9
	Banco de Dados: Mysql 5.6

Ambientes:
	desenvolvimento
	homologacao
	treinamento
Cada ambiente possuirá 3 usuários padrões além do root: deployer, desenvolvedor e git.
 - O usuario git ficará com a reponsabilidade de armazenar os repositórios de versionamento de cada ambiente.
 - O usuário deployer ficará responsável por versionar o ambiente de homologação e treinamento e executar o deployer do treinamento para produção através da ferramenta deployer, e também por gerenciar usuários, grupos e permissões aos deretórios de versionamento.
 - O usuário desenvolvedor será o centralizador de usuarios desenvolvedores em seu grupo, afim de configurar permissões de acesso ao repositório de desenvolvimento.

 Gerenciadores do repositório:

 O repositório treinamento e homologação terá como proprietário o usuario git e o grupo deployer
 O repositório desenvolvimento terá como prprietário o usuário git e o grupo desenvolvedor

 Além dos usuários padrões da configuração do sistema de deployer, poderão ser criados usuários que utilizarão detreminados repositórios de acordo com sua responsabiliodade.
 Um usuário criado com a responsabilidade de desenvolvimento, irá ser adicionado ao grupo desenvolvedor onde poderá fazer clone, pull e push do repositório desenvolvimento. O usuarios com responsábilidade de deploy será incluido no grupo deployer, onde poderá fazer as operações de clone, pull e push dos repositŕios de homologação e treinamento.


 O deployer.php ficará armazenado no diretório padrão do usuário git e será executado automaticamente pelo sistema de post-receive do git do repositŕio de treinamento, afim de automatizar o deploy para produção.

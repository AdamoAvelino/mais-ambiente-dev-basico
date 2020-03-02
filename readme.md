# Maquina desenvolvimento - Sistema de Deployer

	Configuração básica:
	OS: Linux Ubuntu 14.04
	Servidor Web: Apache 2.2.4
	Liguagem Script: PHP 5.5.9
	Banco de Dados: Mysql 5.6

## Ambientes:

 * desenvolvimento
 * homologacao
 * treinamento

## Usuários de Sistema:

 * Git
 * Deployer
 * Desenvolvedor
Cada ambiente possuirá 3 usuários padrões além do root: deployer, desenvolvedor e git.
 * O usuario "Git" ficará com a reponsabilidade concentrar os repositórios de versionamento de cada ambiente.
 * O usuário "Desenvolvedor" centralizará desenvolvedores em seu grupo de usuarios para ter uma configuração de permissões de acesso ao repositório de desenvolvimento para qualquer desenvolvedor(envolvidos no projeto).
 * O usuário "Deployer" ficará responsável por versionar os ambientes de homologação e treinamento e executar o deployer do treinamento para produção através da ferramenta php-deployer. Também gerenciará usuários, grupos e permissões aos diretórios de versionamento.



## Usuários e Responsabilades

 * Adminitrador de Repositórios
 * Desenvolvedor

Além dos usuários padrões da configuração do sistema de deployer, poderão ser criados usuários que utilizarão determinados repositórios de acordo com sua responsabiliodade.
Um usuário criado com a responsabilidade de desenvolvimento, irá ser adicionado ao grupo desenvolvedor onde poderá fazer clone, pull e push do repositório desenvolvimento. O usuarios com responsábilidade de administrar os repositórios, será incluido no grupo deployer, onde poderá fazer as operações de clone, pull e push dos repositŕios de homologação e treinamento.

## Gerenciadores do repositório:

O repositório treinamento e homologação terá como proprietário o usuario git e o grupo deployer
O repositório desenvolvimento terá como proprietário o usuário git e o grupo desenvolvedor

O deployer.php ficará armazenado no diretório padrão do usuário git e será executado automaticamente pelo sistema de post-receive do git do repositŕio de treinamento, afim de automatizar o deploy para produção.

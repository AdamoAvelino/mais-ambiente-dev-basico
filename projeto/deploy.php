<?php
namespace Deployer;
require 'recipe/common.php';

// Configuration

set('ssh_type', 'native');
set('ssh_multiplexing', true);

set('repository', 'vagrant@192.168.0.29:/homo/git/treinamento.git');
set('shared_files', []);
set('shared_dirs', []);
set('writable_dirs', []);

// Servers

server('production', '192.168.0.51')
    ->user('vagrant')
    ->identityFile('/home/git/.ssh/deployerkey')
    ->set('deploy_path', '/var/www/html/sis');


// Tasks
desc("Criando link da release para sistema");
task('criarlink:sistema', function(){
run('ln -sf var/www/html/sistema/ /var/www/html/sis');
});
after('success', 'criarlink:sistema');
/*
desc('Restart PHP-FPM service');
task('php-fpm:restart', function () {
    // The user must have rights for restart service
    // /etc/sudoers: username ALL=NOPASSWD:/bin/systemctl restart php-fpm.service
    run('sudo systemctl restart php-fpm.service');
});
after('deploy:symlink', 'php-fpm:restart');
*/
desc('Deploy your project');
task('deploy', [
    'deploy:prepare',
    'deploy:lock',
    'deploy:release',
    'deploy:update_code',
    'deploy:shared',
    'deploy:writable',
    'deploy:clear_paths',
    'deploy:symlink',
    'deploy:unlock',
    'cleanup',
    'success'
]);

// [Optional] if deploy fails automatically unlock.
after('deploy:failed', 'deploy:unlock');

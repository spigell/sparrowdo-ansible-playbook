# SYNOPSIS

Simple module to run ansible-playbook on remote hosts.

# INSTALL

    $ zef install https://github.com/spigell/sparrowdo-ansible-playbook.git

# USAGE

    $ cat sparrowfile
    module_run 'Ansible::Playbook', %(
      playbook => '/ansible/infra.yml',
      inventory => 'inventories/staging/hosts',
      tags => config<tags>,
      verbose => config<verbose>,
      vars => %(
        docker_root_dir => '/tmp',
        virtual => 'yes'
      )
    );

## Parameters
 - playbook

 /path/to/file on remote machine.

 - ansible-repo-path (Optional)

 /path/to/directory to your ansible's root.

 - inventory (Optional)

 /path/to/file to your ansible's inventory

 - vars

 Hash for extra vars.

 - tags(Optional)

 your tags for ansible-playbook command.

 - verbose(Optional)
 
 if True adds '-vvv' key to ansible-playbook command.

# Author

Spigell

# License

Artistic-2.0

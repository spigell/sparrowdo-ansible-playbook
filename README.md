# SYNOPSIS

Simple module to run ansible-playbook on remote hosts.

# INSTALL

    $ zef install https://github.com/spigell/sparrowdo-ansible-playbook.git

# USAGE

    $ cat sparrowfile

    module_run 'Ansible::Playbook', %(
      playbook => '/home/vagrant/coffeenet/masterhosts.yml',
      tags => 'sparrow',
      ansible-repo-path => '/home/vagrant/coffeenet',
      verbose => True
    );

## Parameters
 - playbook
 /path/to/file on remote machine.

 - ansible-repo-path (Optional)
 /path/to/directory to your ansible's root.

 - tags(Optional)
 your tags for ansible-playbook command.

 - verbose
 if True adds '-vvv' key to ansible-playbook command.

# Author

Spigell

# License

Artistic-2.0

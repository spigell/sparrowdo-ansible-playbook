use v6;

unit module Sparrowdo::Ansible::Playbook;



use YAMLish;
use Sparrowdo;
use Sparrowdo::Core::DSL::Template;
use Sparrowdo::Core::DSL::Bash;


our sub tasks (%args) {

  my $inventory_file = '/tmp/inventory';

  my $playbook_file = %args<playbook>;
  my $temp_playbook = '/tmp/play.yaml';

  Sparrowdo::MAIN::_scp $playbook_file, $temp_playbook,1;



  my %playbook = Hash.new;
  %playbook = load-yaml(slurp $temp_playbook);

  my $hosts = %playbook<hosts>;


  my $templ = "
[[% hosts %]]
127.0.0.1 ansible_connection=local
";

  template-create $inventory_file, %(
    source => $templ,
    variables => %(
      hosts => $hosts
    )
  );

  bash "cat $inventory_file", %(
    description => 'show final inventory'
  );

  my $ansible-playbook-cmd = '';

  $ansible-playbook-cmd ~= qq { cd %args<ansible-repo-path> && } if %args<ansible-repo-path>;
  $ansible-playbook-cmd ~= qq { ansible-playbook -i $inventory_file $playbook_file };
  $ansible-playbook-cmd ~= qq { --tags=%args<tags> } if %args<tags>;
  $ansible-playbook-cmd ~= ' -vvv' if %args<verbose>;


  bash "$ansible-playbook-cmd", %(
    description => 'run ansible-playbook'
  );

}



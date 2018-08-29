use v6;

unit module Sparrowdo::Ansible::Playbook;

use YAMLish;
use Sparrowdo;
use Sparrowdo::Core::DSL::Template;
use Sparrowdo::Core::DSL::Bash;


our sub tasks (%args) {

  my $bash_debug = %args<debug>;
  my $playbook_file = %args<playbook>;
  my $root_dir = '';
  my $inventory_file = '';

  if %args<ansible-repo-path> {
    $root_dir = %args<ansible-repo-path>;

  } else {

    $root_dir = $playbook_file.IO.dirname;
  }


  my $temp_playbook = '/tmp/play.yaml';

  Sparrowdo::MAIN::_scp $playbook_file, $temp_playbook,1;

  my %playbook = Hash.new;
  %playbook = load-yaml(slurp $temp_playbook);
  my $hosts = %playbook<hosts>;

  if not %args<inventory> {


    $inventory_file = '/tmp/inventory';

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
      description => 'show generated inventory'
    );

  } else {

    $inventory_file = %args<inventory>;
  }


  my $ansible-playbook-cmd = '';

  $ansible-playbook-cmd ~= qq { cd $root_dir && };
  $ansible-playbook-cmd ~= qq { ansible-playbook -i $inventory_file $playbook_file };
  $ansible-playbook-cmd ~= qq { --tags=%args<tags> } if %args<tags>;
  $ansible-playbook-cmd ~= qq { --limit $hosts\[0\] };
  $ansible-playbook-cmd ~= qq { -c local };
  $ansible-playbook-cmd ~= ' -vvv' if %args<verbose>;

  if %args<vars> {
    for %args<vars>.kv -> $key, $val {
      $ansible-playbook-cmd ~= qq { -e '$key=$val' }
    }
  }


  bash "$ansible-playbook-cmd", %(
    description => 'run ansible-playbook',
    envvars => %(
      ANSIBLE_FORCE_COLOR => 'true'
    ),
    debug => $bash_debug
  )

}



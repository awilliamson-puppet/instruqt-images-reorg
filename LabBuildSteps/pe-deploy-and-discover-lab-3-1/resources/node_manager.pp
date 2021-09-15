node_group { 'PE Master':
  ensure               => 'present',
  classes              => {
  'pe_repo'            => {
    'compile_master_pool_address' => 'puppet'
  },
  'pe_repo::platform::el_7_x86_64' => {

  },
  'pe_repo::platform::windows_x86_64' => {

  },
  'pe_repo::platform::windowsfips_x86_64' => {

  },
  'puppet_enterprise::profile::master' => {
    'replication_mode' => 'none'
  }
},
  environment          => 'production',
  override_environment => 'false',
  parent               => 'PE Infrastructure',
  provider             => 'https',
  rule                 => ['or',
  ['and',
    ['=',
      ['trusted', 'extensions', 'pp_auth_role'],
      'pe_compiler']],
  ['=', 'name', 'puppet.c.kmo-instruqt.internal']],
}

node_group { 'PE Agent':
  ensure               => 'present',
  classes              => {
  'puppet_enterprise::profile::agent' => {
    'pcp_broker_host' => 'puppet',
    'primary_uris' => ['puppet']
  }
},
  environment          => 'production',
  override_environment => 'false',
  parent               => 'PE Infrastructure',
  provider             => 'https',
  rule                 => ['and',
  ['~',
    ['fact', 'aio_agent_version'],
    '.+']],
}

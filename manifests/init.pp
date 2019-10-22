# Setup fusioninventory agent and its tasks and plugins
#
# @summary deploy fusioninventory agent and its tasks on a system
#
# @example
#   include fusioninventory
class fusioninventory (
  Boolean $manage_package,
  Boolean $manage_config,
  Enum['service'] $run_mode,
  String $package,
  Array $additional_packages,
  String $config,
  String $server,
  String $service,
  Boolean $no_proxy = true,
  Hash $config_hash,
  Hash $additional_settings = {},
){
  if $manage_package {
    ensure_packages($package)
    ensure_packages($additional_packages)
  }
  if $manage_config {
    file {$config:
      ensure  => file,
      content => epp('fusioninventory/agent_config.epp'),
    }
    if $manage_package {
      Package[$package] -> File[$config]
    }
  }
  case $run_mode {
    'service': {
      service{$service:
        ensure => running,
        enable => true,
      }
      if $manage_config {
        File[$config] ~> Service[$service]
      }
    }
  }
}

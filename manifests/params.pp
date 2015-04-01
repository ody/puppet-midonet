# Define midonet::params
#
# Actions:
#   Just a params class...

class midonet::params {

  $api_ip                       = '127.0.0.1'
  $cassandra_replication_factor = 3
  $cassandra_servers            = '127.0.0.1'
  $keystone_host                = '127.0.0.1'
  $keystone_port                = '35357'
  $keystone_token               = ''
  $repo_baseurl                 = 'http://repo.midonet.org'
  $openstack_version            = 'juno'
  $vtep_enabled                 = false
  $zookeeper_servers            = '127.0.0.1:2181'

  if $::operatingsystemmajrelease {
    $os_maj_release = $::operatingsystemmajrelease
  } else {
    $os_versions = split($::operatingsystemrelease, '[.]')
    $os_maj_release = $os_versions[0]
  }

}

class midonet::params {

  $api_ip                        = '127.0.0.1'

  $cassandra_replication_factor  = 3,
  $cassandra_servers             = '',

  $keystone_host                 = '127.0.0.1',
  $keystone_port                 = '35357',
  $keystone_token                = '',

  $repo_midonet                  = 'http://repo.midonet.org',
  $repo_midonet_version_number   = 'v2014.11',
  $repo_midonet_version_friendly = 'juno'

  $zookeeper_servers             = '',

}
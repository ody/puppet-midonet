# Define midonet::params
#
# Actions:
#   Just a params class...

class midonet::params {

  $cassandra_replication_factor = 3
  $cassandra_servers            = '127.0.0.1'
  $keystone_host                = '127.0.0.1'
  $keystone_port                = '35357'
  $keystone_token               = ''
  $midonet_api_ip               = '127.0.0.1'
  $midonet_vtep_enabled         = false
  $midonet_xml_path             = '/usr/share/midonet-api/WEB-INF'
  $openstack_version            = 'juno'
  $repo_baseurl                 = 'http://repo.midonet.org'
  $tomcat_manage                = true
  $tomcat_xml_path              = '/etc/tomcat/Catalina/localhost',
  $zookeeper_servers            = '127.0.0.1:2181'

  if $::operatingsystemmajrelease {
    $os_maj_release = $::operatingsystemmajrelease
  } else {
    $os_versions = split($::operatingsystemrelease, '[.]')
    $os_maj_release = $os_versions[0]
  }

}

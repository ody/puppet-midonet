# Define midonet::agent
#
# Actions:
#   Installs and configures the Midonet agent

class midonet::agent(

  $zookeeper_servers            = $::midonet::params::zookeeper_servers
  $cassandra_replication_factor = $::midonet::params::cassandra_replication_factor
  $cassandra_servers            = $::midonet::params::cassandra_servers

) inherits midonet::params {

  case $::osfamily {

    default: {

      notify { 'Non-enterprise Linux derivatives are currently not supported.':}

    }

    'RedHat': {

      require midonet::repo

      package { 'midolman':
        ensure => present,
      }

      midolman_config { 'cassandra/replication_factor':
        value => $cassandra_replication_factor,
      }

      midolman_config { 'cassandra/servers':
        value => $cassandra_servers,
      }

      midolman_config { 'zookeeper/zookeeper_hosts':
        value => $zookeeper_servers,
      }

    }
  }
}

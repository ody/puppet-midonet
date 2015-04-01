# Define midonet::api
#
# Actions:
#   Installs and configures the Midonet API services.
#
# Requires:
#   This class makes use of the puppetlabs-tomcat module, which can be found at
#   https://forge.puppetlabs.com/puppetlabs/tomcat .
#
#   You should also already have Java installed, perhaps with something like
#   https://forge.puppetlabs.com/puppetlabs/java .

class midonet::api (

  $api_ip            = $::midonet::params::api_ip
  $keystone_host     = $::midonet::params::keystone_host
  $keystone_port     = $::midonet::params::keystone_port
  $keystone_token    = $::midonet::params::keystone_token
  $vtep_enabled      = $::midonet::params::vtep_enabled
  $zookeeper_servers = $::midonet::params::zookeeper_servers

) inherits midonet::params {

  case $::osfamily {

    default: {

      notify { 'Non-enterprise Linux derivatives are currently not supported.':}

    }

    'RedHat': {

      class { 'tomcat':
        install_from_source => false,
      }

      tomcat::instance { 'default':
        package_name => 'tomcat',
      }

      tomcat::service { 'default':
        use_jsvc     => false,
        use_init     => true,
        service_name => 'tomcat',
      }

      package { 'midonet-api':
        ensure  => present,
        require => Tomcat::Instance['default']
      }

      file { '/etc/tomcat/Catalina/localhost/midonet-api.xml':
        ensure  => present,
        group   => 'root',
        owner   => 'root',
        source  => 'puppet:///modules/midonet/midonet-api/midonet-api.xml',
        require => Package['midonet-api'],
        notify  => Service['tomcat'],
      }

      file { '/usr/share/midonet-api/WEB-INF/web.xml':
        ensure  => present,
        content => template('midonet/midonet-api/web.xml.erb'),
        require => Package['midonet-api'],
        notify  => Service['tomcat'],
      }

    }
  }
}

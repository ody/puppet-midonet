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
  $keystone_host        = $::midonet::params::keystone_host,
  $keystone_port        = $::midonet::params::keystone_port,
  $keystone_token       = $::midonet::params::keystone_token,
  $midonet_api_ip       = $::midonet::params::midonet_api_ip,
  $midonet_xml_path     = $::midonet::params::midonet_xml_path,
  $midonet_vtep_enabled = $::midonet::params::vtep_enabled,
  $tomcat_manage        = $::midonet::params::tomcat_manage,
  $tomcat_xml_path      = $::midonet::params::tomcat_config_path,
  $zookeeper_servers    = $::midonet::params::zookeeper_servers,
) inherits midonet::params {
  case $::osfamily {
    'RedHat': {

      require midonet::repo

      if $tomcat_manage == true {

        Package { require => Tomcat::Instance['default'], }

        File { notify => Service['tomcat'], }

        class { 'tomcat': install_from_source => false, }

        tomcat::instance { 'default': package_name => 'tomcat', }

        tomcat::service { 'default':
          use_jsvc     => false,
          use_init     => true,
          service_name => 'tomcat',
        }
      }

      package { 'midonet-api': ensure  => present, }

      file { "${tomcat_xml_path}/midonet-api.xml":
        ensure  => present,
        group   => 'root',
        owner   => 'root',
        source  => 'puppet:///modules/midonet/midonet-api/midonet-api.xml',
        require => Package['midonet-api'],
      }

      file { "${midonet_xml_path}/web.xml":
        ensure  => present,
        content => template('midonet/midonet-api/web.xml.erb'),
        require => Package['midonet-api'],
      }
    }
    default: {
      fail('Non-enterprise Linux derivatives are currently not supported.')
    }
  }
}

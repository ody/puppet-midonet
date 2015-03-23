class midonet::api (

  $keystone_host     = $::midonet::params::keystone_host,
  $keystone_port     = $::midonet::params::keystone_port,
  $keystone_token    = $::midonet::params::keystone_token,
  $zookeeper_servers = $::midonet::params::zookeeper_servers,

) inherits midonet::params {

  case $osfamily {
    'Debian' : {
      
      notify { 'Debian and its derivatives are currently not supported.' : }

    }

    'RedHat' : {

      package { 'tomcat' :
        ensure => present,
      }

      service { 'tomcat' :
        enable  => true,
        ensure  => running,
        require => Package['tomcat'],
      }

      package { 'midonet-api' :
        ensure  => present,
        require => Package['tomcat']
      }

      file { '/etc/tomcat/Catalina/localhost/midonet-api.xml' :
        ensure  => present,
        group   => 'root',
        owner   => 'root',
        source  => 'puppet:///modules/midonet/midonet-api/midonet-api.xml',
        require => Package['midonet-api'],
        notify  => Service['tomcat'],
      }

      file { '/usr/share/midonet-api/WEB-INF/web.xml' :
        content => template('midonet/midonet-api/web.xml.erb'),
        ensure  => present,
        require => Package['midonet-api'],
        notify  => Service['tomcat'],
      }

    }
  }

}
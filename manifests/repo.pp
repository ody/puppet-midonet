class midonet::repo(

  $repo_midonet_url              = $::midonet::params::repo_midonet_url,
  $repo_midonet_version_number   = $::midonet::params::repo_midonet_version_number,
  $repo_midonet_version_friendly = $::midoent::params::repo_midonet_version_friendly,

) inherits midonet::params {

  case $::osfamily {
    'Debian' : { 

      notify { 'Debian and its derivatives are currently not supported.' : }

    }

    'RedHat' : {

      if $repo_manage_epel {
        include epel
      }

      file { '/etc/pki/rpm-gpg/GPG-MIDOKURA' :
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => 'puppet:///modules/midonet/GPG-MIDOKURA',
        notify => Exec['import-key-midokura']
      }

      exec { 'import-key-midokura' :
        command   => 'rpm --import /etc/pki/rpm-gpg/GPG-MIDOKURA',
        logoutput => 'on_failure',
        path      => '/bin:/usr/bin:/sbin:/usr/sbin',
      }

      Yumrepo {
        enabled  => 1,
        gpgcheck => 1,
        notify   => Exec['update-repos'],
      }

      yumrepo { 'midonet':
        baseurl  => "${repo_midonet_url}/midonet/${repo_midonet_version_number}/RHEL/${::operatingsystemmajrelease}/stable",
        descr    => 'Midonet Repository',
        gpgkey   => 'file:///etc/pki/rpm-gpg/GPG-MIDOKURA',
        require  => File['/etc/pki/rpm-gpg/GPG-MIDOKURA'],
      }

      yumrepo { 'midonet-openstack':
        baseurl  => "${repo_midonet_url}/openstack-${repo_midonet_version_friendly}/RHEL/${::operatingsystemmajrelease}/stable",
        descr    => 'Midonet OpenStacek Plugin Repository',
        gpgkey   => 'file:///etc/pki/rpm-gpg/GPG-MIDOKURA',
        require  => File['/etc/pki/rpm-gpg/GPG-MIDOKURA'],
      }

      yumrepo { 'midonet-misc':
        baseurl  => "${repo_midonet_url}/misc/RHEL/${::operatingsystemmajrelease}",
        descr    => 'Midonet Misc Repository',
        gpgkey   => 'file:///etc/pki/rpm-gpg/GPG-MIDOKURA',
      }

      exec { 'update-repos' :
        command   => 'yum clean all && yum makecache',
        logoutput => 'on_failure',
        path      => '/bin:/usr/bin:/sbin:/usr/sbin',
      }

    }
  }
}
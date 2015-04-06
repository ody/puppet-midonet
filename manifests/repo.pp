# Define midonet::repo
#
# Actions:
#   This module installs the Midonet repositories

class midonet::repo(
  $openstack_version,
  $os_maj_release = $::midonet::params::os_maj_release,
  $repo_baseurl   = $::midonet::params::repo_baseurl,
) inherits midonet::params {

  $openstack_version_list = [
    'icehouse',
    'juno',
    'kilo'
  ]

  validate_re($openstack_version, $openstack_version_list)

  $midonet_verion = {
    'icehouse' => '2014.11',
    'juno'     => '2015.1',
    'kilo'     => '2015.2',
  }

  case $::osfamily {
    'RedHat' : {

      file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-MIDOKURA':
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => 'puppet:///modules/midonet/RPM-GPG-KEY-MIDOKURA',
        before => Midonet::Rpm_gpg_key['RPM-GPG-KEY-MIDOKURA'],
      }

      midonet::rpm_gpg_key { 'RPM-GPG-KEY-MIDOKURA':
        path   => '/etc/pki/rpm-gpg/RPM-GPG-KEY-MIDOKURA',
        before => Yumrepo['midonet','midonet-openstack','midonet-misc'],
      }

      Yumrepo {
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-MIDOKURA'
        notify   => Exec['update-repos'],
      }

      yumrepo { 'midonet':
        baseurl => "${repo_baseurl}/midonet/${midonet_version[$openstack_version]}/RHEL/${os_maj_release}/stable/",
        descr   => 'Midonet Repository',
        gpgkey  => 'file:///etc/pki/rpm-gpg/GPG-MIDOKURA',
      }

      yumrepo { 'midonet-openstack':
        baseurl => "${repo_baseurl}/openstack-${openstack_version}/RHEL/${os_maj_release}/stable/",
        descr   => 'Midonet OpenStacek Plugin Repository',
      }

      yumrepo { 'midonet-misc':
        baseurl => "${repo_baseurl}/misc/RHEL/${os_maj_release}/misc/",
        descr   => 'Midonet Misc Repository',
      }

      exec { 'update-repos':
        command   => 'yum clean all && yum makecache',
        logoutput => 'on_failure',
        path      => '/bin:/usr/bin:/sbin:/usr/sbin',
      }
    }
    default: {
      fail('Non-enterprise Linux derivatives are currently not supported.')
    }
  }
}

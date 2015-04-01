# Define midonet::rpm_gpg_key
#
# Attribution:
#   This type has been copied from stahnma's excellent epel module, which can be
#   found at https://forge.puppetlabs.com/stahnma/epel.
#
# Actions:
#
#   Import a RPM GPG key
#
# Parameters:
#
#   [*path*]
#     Path of the RPM GPG key to import
#
# Requires:
#   An Enterprise Linux (EL) varient (e.g. CentOS, RHEL, et. al.)
#
# Sample Usage:
#  midonet::rpm_gpg_key{ "RPM-GPG-KEY-MIDOKURA":
#    path => "/etc/pki/rpm-gpg/RPM-GPG-KEY-MIDOKURA"
#  }

define midonet::rpm_gpg_key($path) {
  # Given the path to a key, see if it is imported, if not, import it
  exec {  "import-${name}":
    path      => '/bin:/usr/bin:/sbin:/usr/sbin',
    command   => "rpm --import ${path}",
    unless    => "rpm -q gpg-pubkey-$(echo $(gpg --throw-keyids < ${path}) | cut --characters=11-18 | tr '[A-Z]' '[a-z]')",
    require   => File[$path],
    logoutput => 'on_failure',
  }
}

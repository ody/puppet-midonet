# Define midonet::cli
#
# Actions:
#   Installs and configures the Midonet CLI
#
# Requires:
#   This class requires packages provided by the Midonet repositories, which can
#   be installed via the midonet::cli class.

class midonet::cli {

  case $::osfamily {
    'RedHat': {

      require midonet::repo

      package { 'python-midonetclient':
        ensure => present,
      }
    }
    default: {
      fail('Non-enterprise Linux derivatives are currently not supported.')
    }
  }
}

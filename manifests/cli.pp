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

    default: {

      notify { 'Non-enterprise Linux derivatives are currently not supported.':}

    }

    'RedHat': {

      package { 'python-midonetclient':
        ensure => present,
      }

    }
  }
}

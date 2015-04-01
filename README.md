# puppet-midonet

## Getting Started

Install the repositories

    class { 'midonet::repo':
      openstack_version => 'juno',
    }

Install the agent

    include midonet::agent

Install the CLI

    include midonet::cli

Install the API server

    include midonet::api

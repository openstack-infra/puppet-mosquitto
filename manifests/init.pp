# == Class: mosquitto
#
# Full description of class mosquitto here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class mosquitto (
) {
    # TODO: can drop this PPA once the service is running on Ubuntu 18.04
    apt::ppa { 'ppa:mosquitto-dev/mosquitto-ppa': }

    package {'mosquitto':
      ensure => latest,
    }
}

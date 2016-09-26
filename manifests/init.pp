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
    apt::ppa { 'ppa:mosquitto-dev/mosquitto-ppa': }

    package {'mosquitto':
      ensure => present,
    }
}

# Copyright 2016 Hewlett-Packard Development Company, L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# == Class: mosquitto
#
class mosquitto::server (
  $pid_file = '/var/run/mosquitto.pid',
  $log_file = '/var/log/mosquitto/mosquitto.log',
  $persistence_location = '/var/lib/mosquitto/',
  $infra_service_username = 'infra',
  $infra_service_password,
  $websocket_port = 80,
) {

  exec {'passwd_file':
    command     => "mosquitto_passwd -c -b /etc/mosquitto.infra_service.pw ${infra_service_username} ${infra_service_password}",
    refreshonly => true,
    subscribe   => Package['mosquitto'],
  }

  file {'/etc/mosquitto/infra_service.acl':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    replace => true
    content => template('mosquitto/mosquitto.acl.erb'),
    require => exec['passwd_file'],
  }

  file {'/etc/mosquitto/mosquitto.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('mosquitto/mosquitto.conf.erb'),
    require => File['/etc/mosquitto/mosquitto.infra_service.acl'],
  }
}

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
  $enable_tls = false,
  $websocket_tls_port = 8080,
  $ca_file = undef,
  $cert_file = undef,
  $key_file = undef,
) {

  file {'/etc/mosquitto/infra_service.pw':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    replace => true,
    require => Package['mosquitto'],
  }

  exec {'passwd_file':
    command => "/usr/bin/mosquitto_passwd -b /etc/mosquitto/infra_service.pw ${infra_service_username} ${infra_service_password}",
    require => File['/etc/mosquitto/infra_service.pw']
  }

  file {'/etc/mosquitto/infra_service.acl':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    replace => true,
    content => template('mosquitto/mosquitto.acl.erb'),
    require => Exec['passwd_file'],
  }

  file { '/etc/mosquitto/ca.crt':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => $ca_file,
    require => Package['mosquitto'],
    before  => File['/etc/mosquitto/mosquitto.conf'],
  }

  file { '/etc/mosquitto/server.crt':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => $cert_file,
    require => Package['mosquitto'],
    before  => File['/etc/mosquitto/mosquitto.conf'],
  }

  file { '/etc/mosquitto/server.key':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => $key_file,
    require => Package['mosquitto'],
    before  => File['/etc/mosquitto/mosquitto.conf'],
  }

  file {'/etc/mosquitto/mosquitto.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('mosquitto/mosquitto.conf.erb'),
    require => File['/etc/mosquitto/infra_service.acl'],
  }
}

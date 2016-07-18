# == Class: mosquitto::config
#
# This class is used to manage arbitrary mosquitto configurations.
#
# === Parameters
#
# [*mosquitto_config*]
#   (optional) Allow configuration of arbitrary mosquitto configurations.
#   The value is an hash of mosquitto_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   mosquitto_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class mosquitto::config (
  $mosquitto_config = {},
) {

  validate_hash($mosquitto_config)

  create_resources('mosquitto_config', $mosquitto_config)
}

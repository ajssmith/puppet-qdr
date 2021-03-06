# == Class: qdr
#
# Full description of class qdr here.
#
# === Parameters
#
# [*ensure_package*]
#   (optional) The state of the qdr packages
#   Defaults to 'installed'
#
# [*ensure_service*]
#   (optional) The state of the qdr service
#   Defaults to 'running'
#
# [*enable_service*]
#   (optional) The administrative status of the qdr service
#   Defaults to 'true'
#
# [*listener_addr*]
#   (optional) Service host name
#   Defaults to '127.0.0.1'
#
# [*listner_auth_peer*]
#   (optional) Require the peer's identity to be authenticated.
#   Defaults to 'no'
#
# [*listner_idle_timeout*]
#   (optional) Idle timeout, in seconds, for connection through the listener
#   Defaults to '16'
#
# [*listener_max_frame_size*]
#   (optional) Maximum frame size used for a message delivery over the connection
#   Defaults to '16384'
#
# [*listener_port*]
#   (optional) Service port number (AMQP)
#   Defaults to '5672'
#
# [*listener_require_encrypt*]
#   (optional) Require the connection to the peer to be encrypted
#   Defaults to  'no'
#
# [*listener_require_ssl*]
#   (optional) Require the use of SSL or TLS on the connection
#   Defaults to 'no'
#
# [*listener_sasl_mech*]
#   (optional) List of accepted SASL auth mechanisms
#   Defaults to 'ANONYMOUS'
#
# [*listener_ssl_cert_db*]
#   (optional) Path to certificate db
#   Defaults to undef
#
# [*listener_ssl_cert_file*]
#   (optional) Path to certificat file
#   Defaults to undef
#
# [*listener_ssl_key_file*]
#   (optional) Path to private key file
#   Defaults to undef
#
# [*listener_ssl_pw_file*]
#   (optional) Path to password file for certificate key
#   Defaults to undef
#
# [*listener_ssl_password*]
#   (optional) Password to be supplied
#   Defaults to undef
#
# [*listener_trusted_certs*]
#   (optional) Path to file containing trusted certificates
#   Defaults to 'UNSET'
#
# [*log_module*]
#   (optional) The log module to configure
#   Defaults to 'DEFAULT' 
#
# [*log_enable*]
#   (optional) Log level for a module
#   Defaults to 'debug+' 
#
# [*log_output*]
#   (optional) Target destination for log message
#   Defaults to '/var/log/qdrouterd.log' 
#
# [*router_debug_dump*]
#   (optional) Path to file for debugging information
#   Defaults to '/var/log'
#
# [*router_hello_interval*]
#   (optional) Router HELLO message interval in seconds
#   Defaults to '1'
#
# [*router_hello_max_age*]
#   (optional) Neighbor router age timeout in seconds
#   Defaults to '3'
#
# [*router_id*]
#   (optional) Router unique identifer
#   Defaults to 'Router.fqdn"
#
# [*router_mode*]
#   (optional) Operational mode for Router (standalone or interconnected)
#   Defaults to 'standalone'
#
# [*router_ra_interval*]
#   (optional) Router advertisement interval
#   Defaults to '30'
#
# [*router_ra_interval_flux*]
#   (optional) Router advertisement interval during topology changes
#   Defaults to '4'
#
# [*router_remote_ls_max_age*]
#   (optional) Router advertisement aging interval
#   Defaults to '60'
#
# [*router_sasl_name*]
#   (optional) Name of SASL configuration
#   Defaults to 'qdrouterd'
#
# [*router_sasl_path*]
#   (optional) Path to the SASL configuration file
#   Defaults to '/etc/sasl2'
#
# [*router_worker_threads*]
#   (optional) Number of threads create to process message traffic
#   Defaults to $::processorcount
#
class qdr(
  $ensure_package             = 'installed',
  $ensure_service             = 'running',
  $enable_service             = true,
  $listener_addr              = '127.0.0.1',
  $listener_auth_peer         = 'no',
  $listener_idle_timout       = '16',
  $listener_max_frame_size    = '16384',
  $listener_port              = '5672',
  $listener_require_encrypt   = 'no',
  $listener_require_ssl       = 'no',
  $listener_sasl_mech         = 'ANONYMOUS',
  $listener_ssl_cert_db       = undef,
  $listener_ssl_cert_file     = undef,
  $listener_ssl_key_file      = undef,
  $listener_ssl_pw_file       = undef,
  $listener_ssl_password      = undef,
  $listener_trusted_certs     = 'UNSET',
  $log_enable                 = 'debug+',
  $log_module                 = 'DEFAULT',
  $log_output                 = '/var/log/qdrouterd.log',
  $router_debug_dump          = '/var/log',
  $router_hello_interval      = '1',
  $router_hello_max_age       = '3',
  $router_id                  = "Router.${::fqdn}",
  $router_mode                = 'standalone',
  $router_ra_interval         = '30',
  $router_ra_interval_flux    = '4',
  $router_remote_ls_max_age   = '60',
  $router_sasl_name           = 'qdrouterd',
  $router_sasl_path           = '/etc/sasl2',
  $router_worker_threads      = $::processorcount ,
) inherits qdr::params {

  validate_string($router_worker_threads)
  validate_absolute_path($router_debug_dump)
  validate_absolute_path($router_sasl_path)
  validate_string($router_sasl_name)
  validate_re($router_mode,'^(standalone$|interior$)')
  validate_string($router_id)
  validate_string($listener_addr)
  validate_re($listener_port, '\d+')
  validate_re($listener_auth_peer,'^(yes$|no$)')
  validate_string($listener_sasl_mech)
  
  class { '::qdr::install': } ->
  class { '::qdr::config': } ~>
  class { '::qdr::service': }

}

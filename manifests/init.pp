# Class: postfix
#
# This module manages postfix
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

# This file is part of the postfix Puppet module.
#
#     The postfix Puppet module is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     The postfix Puppet module is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with the postfix Puppet module.  If not, see <http://www.gnu.org/licenses/>.

# [Remember: No empty lines between comments and class definition]
class postfix (
  $remove_sendmail  = undef,
  $myorigin         = undef,
  $relayhost        = undef,
  $relayhost_port   = undef
) inherits postfix::params {

  if $remove_sendmail {

    service{$postfix::params::sendmail_service:
      ensure => stopped,
      before => Package[$postfix::params::sendmail_package]
    }

    package{$postfix::params::sendmail_package:
      ensure => $postfix::params::sendmail_ensure,
      before => Package['postfix'],
    }
  }

  package{'postfix':
    ensure  => installed,
    name    => $postfix::params::package,
    before  => [File['postfix_config'],Augeas['postfix_config']],
  }

  file{'postfix_config':
    ensure  => file,
    path    => $postfix::params::config_file,
  }

  service{'postfix':
    ensure      => running,
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
    subscribe   => [File['postfix_config'],Augeas['postfix_config']]
  }

  if $myorigin {
    $myorigin_augeas = "set myorigin ${myorigin}"
  } else {
    $myorigin_augeas = "rm myorigin"
  }

  # relayhost could have just been a string with the port added to it
  # but expressing relayhost_port as a separate parameter is a better abstraction
  if $relayhost {
    if $relayhost_port {
      $relayhost_augeas = "set relayhost ${relayhost}:${relayhost_port}"
    } else {
      $relayhost_augeas = "set relayhost ${relayhost}"
    }
  } else {
    $relayhost_augeas = "rm relayhost"
  }

  augeas { 'postfix_config':
    context => '/files/etc/postfix/main.cf',
    changes => [
      $myorigin_augeas,
      $relayhost_augeas,
    ],
  }

}

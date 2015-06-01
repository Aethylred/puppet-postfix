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
  $mydestination    = undef,
  $relayhost        = undef,
  $relayhost_port   = undef,
  $daemon_directory = $::postfix::params::daemon_directory,
  $inet_interfaces  = $::postfix::params::inet_interfaces,
) inherits postfix::params {

  if $remove_sendmail {

    # sendmail-cf must be uninstalled first
    package{$postfix::params::sendmailcf_package:
      ensure => $postfix::params::sendmail_ensure,
      before => Package[$postfix::params::sendmail_package],
    }

    package{$postfix::params::sendmail_package:
      ensure => $postfix::params::sendmail_ensure,
      before => Package['postfix'],
    }
  }

  package{'postfix':
    ensure => 'installed',
    name   => $postfix::params::package,
    before => [
      File['postfix_config']
    ],
  }

  file{'postfix_config':
    ensure  => 'file',
    path    => $postfix::params::config_file,
    content => template('postfix/main.cf.erb')
  }

  service{'postfix':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => [
      File['postfix_config']
    ]
  }

}

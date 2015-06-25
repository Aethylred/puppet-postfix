# Class: postfix::params
#
# This module manages the global variables for the postfix puppet module
#
# Sample Usage:
# Do not use, this class is included as required by other postfix classes.

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
class postfix::params{
  # Set OS family specific variables here, and test for supported OS families.
  case $::osfamily{
    /Debian/: {
      $sendmail_ensure  = 'purged'
      $package          = 'postfix'
      $service          = 'postfix'
      $config_file      = '/etc/postfix/main.cf'
      $daemon_directory = '/usr/lib/postfix'
    }
    /RedHat/: {
      $sendmail_ensure  = 'absent'
      $package          = 'postfix'
      $service          = 'postfix'
      $config_file      = '/etc/postfix/main.cf'
      $daemon_directory = '/usr/libexec/postfix'
    }
    default: {
      fail("The postfix module does not support the ${::osfamily} family of operating systems.")
    }
  }
  
  # Set OS independent varibles here
  $sendmail_package   = 'sendmail'
  $sendmailcf_package = 'sendmail-cf'
  $sendmail_service   = 'sendmail'
  $inet_interfaces    = 'localhost'
}

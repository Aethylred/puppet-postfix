# puppet-postfix

This is a puppet module for installing, configuring and managing the [postfix][1] message transfer agent.

[![Build Status](https://travis-ci.org/Aethylred/puppet-postfix.png)](https://travis-ci.org/Aethylred/puppet-postfix)

# Intent

The intention of this module is to provide a module that installs and configures postfix using a parametised class, rather than using custom template files.

# Postfix vs. Sendmail

There are many reasons to choose between [sendmail][2] and postfix, but in this case it was that the postfix configuration is a simple text file. The sendmail configuration has to be compiled, and this compilation step makes it difficult for Puppet to tell if a configuration change has been implemented, which in turn makes it difficult to create a module that is truly idempotent.

# Default Usage

To install postfix with the default configuration:

```puppet
include postfix
```

# Configuration with Parameters

The postfix class is parametric and allows a single declaration to configure the postfix service. At this stage it only configures a few settings to allow the set up of a SMTP relay that forwards all messages to another SMTP host. The following example replicates the default configuration:

```puppet
class {'postfix':
	remove_sendmail => false,
	myorigin			=>	undef,
	relayhost			=> undef,
	relayhost_port	=> undef,
}
	
```

## Parameters

* `remove_sendmail` The sendmail service and packages will be removed from the system if this parameter is set to `true`. Default is `false`.

* `myorigin` This sets the default domain part of all outgoing email as per the [postfix documentation](http://www.postfix.org/BASIC_CONFIGURATION_README.html#myorigin). The default is `undef`, which will revert to the system default which is the local hostname.

* `relayhost` This sets the FQDN of the host through which email will be relayed to the internet as per the [postfix documentation](http://www.postfix.org/BASIC_CONFIGURATION_README.html#relayhost). The default is `undef`, which reverts to the system default of attempting to send email directly out through the Internet.

* `relayhost_port` This sets the port for the relay host specified with the `relayhost` parameter. The default is `undef` which leaves the port specifier off the end of the relayhost setting. This parameter does nothing if the `relayhost` parameter is not set.


# Licensing

Update your license details here.

# Attribution

## `puppet-blank` for Puppet Module generation

This module is derived from the puppet-blank module by Aaron Hicks (aethylred@gmail.com)

* https://github.com/Aethylred/puppet-blank

This module has been developed for the use with Open Source Puppet (Apache 2.0 license) for automating server & service deployment.

* http://puppetlabs.com/puppet/puppet-open-source/

## `puppet-bootstrap` for bootstrapping Puppet into Vagrant

The Puppet bootstrap scripts are modified from the [Vagrant](http://www.vagrantup.com/) puppet-bootstrap scripts provided by Hashicorp.

* https://github.com/hashicorp/puppet-bootstrap

The current `Vagrantfile` is configured to use the box [CentOS NoCM Virtualbox](http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box) from the [PuppetLabs box repository](http://puppet-vagrant-boxes.puppetlabs.com/)

### Using the current Vagrant configuration

* Add the Vagrant box to your collection: 

```
$ vagrant box add centos-64-x64-vbox4210-nocm http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box
``` 

*  Start the box: 

```
$ vagrant up
```

### Changing the Vagrant configuration

To use a different Vagrant configuration, add a different base box to your collection and edit the Vagrantfile to specify it. If the base OS of the box is different, specify the correct Puppet bootstrap script by altering the line:

```ruby
  config.vm.box = "centos-64-x64-vbox4210-nocm"
```

### Testing the Puppet module

Vagrant will mount the module directory from the host as `/vagrant` within the VM, and these have to be added to the Puppet configuration. The simplest method is to link the `/vagrant` directory into the puppet modules directory (replace *<modulename\>* with the module's name):

```
$ ln -s /vagrant /etc/puppet/modules/<modulename>
```


To run the smoke tests, logged in as root on the VM run:

```
$ puppet apply /vagrant/tests/init.pp
```

More complex Puppet modules (i.e. those with dependencies on other Puppet modules) may require additional configuration, such as installing the dependencies and adding them to the Puppet configuration.

# Gnu General Public License

This file is part of the postfix Puppet module.

The postfix Puppet module is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

The postfix Puppet module is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with the blank Puppet module.  If not, see <http://www.gnu.org/licenses/>.

[1]:http://www.postfix.org/
[2]:http://www.sendmail.com/sm/open_source/
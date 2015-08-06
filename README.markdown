# puppet-postfix

This is a puppet module for installing, configuring and managing the [postfix][1] message transfer agent.

[![Build Status](https://travis-ci.org/Aethylred/puppet-postfix.png)](https://travis-ci.org/Aethylred/puppet-postfix)

# Intent

The intention of this module is to provide a module that installs and configures postfix using a parametised class and augeas, rather than using custom template files. This included setting up appropriate rspec tests and smoke tests.

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
* `mydestination` This sets the default domain part of all outgoing email as per the [postfix documentation](http://www.postfix.org/BASIC_CONFIGURATION_README.html#mydestination). The default is `undef`, which will revert to the system default which is `$myhostname localhost.$mydomain localhost`.
* `relayhost` This sets the FQDN of the host through which email will be relayed to the internet as per the [postfix documentation](http://www.postfix.org/BASIC_CONFIGURATION_README.html#relayhost). The default is `undef`, which reverts to the system default of attempting to send email directly out through the Internet.
* `relayhost_port` This sets the port for the relay host specified with the `relayhost` parameter. The default is `undef` which leaves the port specifier off the end of the relayhost setting. This parameter does nothing if the `relayhost` parameter is not set.
* `daemon_directory` Sets the directory with Postfix support programs and daemon programs are installed. The default is specific for each operating system. It's _not_ recommended that this parameter be changed.
* `inet_interfaces` Sets the network interface for postfix to bind do. The default value is `localhost`

# Attribution

## `puppet-blank` for Puppet Module generation

This module is derived from the puppet-blank module by Aaron Hicks (aethylred@gmail.com)

* https://github.com/Aethylred/puppet-blank

This module has been developed for the use with Open Source Puppet (Apache 2.0 license) for automating server & service deployment.

* http://puppetlabs.com/puppet/puppet-open-source/

# Licensing

This file is part of the postfix Puppet module.

Licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)

[1]:http://www.postfix.org/
[2]:http://www.sendmail.com/sm/open_source/

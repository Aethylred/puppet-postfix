require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec_puppet_osmash'

RSpec.configure do |c|

  c.treat_symbols_as_metadata_keys_with_true_values = true

  c.before :each do
    # Ensure that we don't accidentally cache facts and environment
    # between test cases.
    Facter::Util::Loader.any_instance.stubs(:load_all)
    Facter.clear
    Facter.clear_messages

    # Store any environment variables away to be restored later
    @old_env = {}
    ENV.each_key {|k| @old_env[k] = ENV[k]}

    if ENV['STRICT_VARIABLES'] == 'yes'
      Puppet.settings[:strict_variables]=true
    end
  end
end

shared_examples :compile, :compile => true do
  it { should compile.with_all_deps }
end

$osmash = Rspec_puppet_osmash.new

$osmash.supported.map! do | os |
  expectations = {
    'sendmail_package'   => 'sendmail',
    'sendmailcf_package' => 'sendmail-cf',
    'sendmail_service'   => 'sendmail',
    'inet_interfaces'    => 'localhost'
  }
  case os['osfamily']
  when 'Debian'
    expectations.merge!( {
      'sendmail_ensure'  => 'purged',
      'package'          => 'postfix',
      'service'          => 'postfix',
      'config_file'      => '/etc/postfix/main.cf',
      'daemon_directory' => '/usr/lib/postfix'
    } )
  when 'RedHat'
    expectations.merge!( {
      'sendmail_ensure'  => 'absent',
      'package'          => 'postfix',
      'service'          => 'postfix',
      'config_file'      => '/etc/postfix/main.cf',
      'daemon_directory' => '/usr/libexec/postfix'
    } )
  end

  os.merge( { 'expectations' => expectations } )
end

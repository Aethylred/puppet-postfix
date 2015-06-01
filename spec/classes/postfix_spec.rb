require 'spec_helper'

describe 'postfix', :type => :class do
  $osmash.supported.each do |os|
    context "on #{os['name']}" do
      let :facts do
        {
          :osfamily => os['osfamily'],
        }
      end
      it { should contain_class('postfix::params') }
      it { should contain_package(os['expectations']['package']) }
      it { should contain_service(os['expectations']['service']) }
      it { should contain_file('postfix_config').with(
        'ensure'  => 'file',
        'path'    => '/etc/postfix/main.cf'
      ) }

      describe 'with no parameters' do
        it { should_not contain_service(os['expectations']['sendmail_service']) }
        it { should_not contain_package(os['expectations']['sendmail_package']) }
        it { should_not contain_package(os['expectations']['sendmailcf_package']) }
        it { should contain_file('postfix_config').without_content(
          %r{^myorigin = }
        ) }
        it { should contain_file('postfix_config').with_content(
          %r{^mydestination = \$myhostname, localhost.\$mydomain, localhost$}
        ) }
        it { should contain_file('postfix_config').without_content(
          %r{^relayhost =}
        ) }
        it { should contain_file('postfix_config').with_content(
          %r{^daemon_directory = #{os['expectations']['daemon_directory']}$}
        ) }
      end

      describe 'when removing sendmail' do
        let :params do
          { :remove_sendmail => true }
        end
        it { should contain_package(os['expectations']['sendmail_package']).with_ensure(os['expectations']['sendmail_ensure']) }
        it { should contain_package(os['expectations']['sendmailcf_package']).with_ensure(os['expectations']['sendmail_ensure']) }
      end

      describe 'when leaving sendmail alone' do
        let :params do
          { :remove_sendmail => false }
        end
        it { should_not contain_package(os['expectations']['sendmail_package']) }
        it { should_not contain_package(os['expectations']['sendmailcf_package']) }
      end

      describe 'when setting myorigin' do
        let :params do
          { :myorigin => 'example.org' }
        end
        it { should contain_file('postfix_config').with_content(
          %r{^myorigin = example.org$}
        ) }
      end

      describe 'when setting mydestination' do
        let :params do
          { :mydestination => 'example.org' }
        end
        it { should contain_file('postfix_config').with_content(
          %r{^mydestination = example.org$}
        ) }
      end

      describe 'when setting a relayhost without a port' do
        let :params do
          { :relayhost => 'example.org' }
        end
        it { should contain_file('postfix_config').with_content(
          %r{^relayhost = example.org$}
        ) }
      end

      describe 'when setting a relayhost with a port' do
        let :params do
          {
            :relayhost      => 'example.org',
            :relayhost_port => '444'
          }
        end
        it { should contain_file('postfix_config').with_content(
          %r{^relayhost = example.org:444$}
        ) }
      end

      describe 'when setting inet_interfaces' do
        let :params do
          { :inet_interfaces => 'all' }
        end
        it { should contain_file('postfix_config').with_content(
          %r{^inet_interfaces = all$}
        ) }
      end

    end
  end
  
  context 'on a Unkown OS' do
    let :facts do
      {
        :osfamily => 'Unknown',
      }
    end
    it { should raise_error(Puppet::Error,
      %r{The postfix module does not support the Unknown family of operating systems.}
    ) }
  end

end

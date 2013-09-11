require 'spec_helper'

describe 'postfix', :type => :class do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily               => 'Debian',
      }
    end
    it { should include_class('postfix::params') }
    it { should contain_package('postfix') }
    it { should contain_service('postfix') }
    it { should contain_file('postfix_config').with(
      'ensure'  => 'file',
      'path'    => '/etc/postfix/main.cf'
    ) }
    it { should contain_augeas('postfix_config') }
    describe 'working with the default main.cf' do
      describe_augeas 'postfix_config', :target => 'etc/postfix/main.cf' do
        it { should_not execute.with_change }
      end
    end
    describe 'working with a modified main.cf' do
      describe_augeas 'postfix_config', :target => 'etc/postfix/main.cf', :fixture => 'etc/postfix/main.modified.cf' do
        it { should execute.with_change }
        it { should execute.idempotently }
      end
    end
    describe 'with remove_sendmail => true' do
      let :params do
        { :remove_sendmail => true }
      end
      it { should contain_service('sendmail').with_ensure('stopped') }
      it { should contain_package('sendmail').with_ensure('purged') }
    end
  end
  context 'on a RedHat OS' do
      let :facts do
        {
          :osfamily               => 'RedHat',
        }
      end
    it { should include_class('postfix::params') }
    it { should contain_package('postfix') }
    it { should contain_service('postfix') }
    it { should contain_file('postfix_config').with(
      'ensure'  => 'file',
      'path'    => '/etc/postfix/main.cf'
    ) }
    it { should contain_augeas('postfix_config') }
    describe 'working with the default main.cf' do
      describe_augeas 'postfix_config', :target => 'etc/postfix/main.cf' do
        it { should_not execute.with_change }
      end
    end
    describe 'working with a modified main.cf' do
      describe_augeas 'postfix_config', :target => 'etc/postfix/main.cf', :fixture => 'etc/postfix/main.modified.cf' do
        it { should execute.with_change }
        it { should execute.idempotently }
      end
    end
    describe 'with remove_sendmail => true' do
      let :params do
        { :remove_sendmail => true }
      end
      it { should contain_service('sendmail').with_ensure('stopped') }
      it { should contain_package('sendmail').with_ensure('absent') }
    end
  end
end
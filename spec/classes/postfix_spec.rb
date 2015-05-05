require 'spec_helper'

describe 'postfix', :type => :class do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily => 'Debian',
      }
    end
    it { should contain_class('postfix::params') }
    it { should contain_package('postfix') }
    it { should contain_service('postfix') }
    it { should contain_file('postfix_config').with(
      'ensure'  => 'file',
      'path'    => '/etc/postfix/main.cf'
    ) }

    describe 'with remove_sendmail => true' do
      let :params do
        { :remove_sendmail => true }
      end
      it { should_not contain_service('sendmail').with_ensure('stopped') }
      it { should contain_package('sendmail').with_ensure('purged') }
      it { should contain_package('sendmail-cf').with_ensure('purged') }
    end
    
  end
  
  context 'on a RedHat OS' do
      let :facts do
        {
          :osfamily => 'RedHat',
        }
      end
    it { should contain_class('postfix::params') }
    it { should contain_package('postfix') }
    it { should contain_service('postfix') }
    it { should contain_file('postfix_config').with(
      'ensure'  => 'file',
      'path'    => '/etc/postfix/main.cf'
    ) }

    describe 'with remove_sendmail => true' do
      let :params do
        { :remove_sendmail => true }
      end
      it { should contain_service('sendmail').with_ensure('stopped') }
      it { should contain_package('sendmail').with_ensure('absent') }
      it { should contain_package('sendmail-cf').with_ensure('absent') }
    end

  end
  
end

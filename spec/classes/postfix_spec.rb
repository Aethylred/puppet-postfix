require 'spec_helper'

describe 'postfix', :type => :class do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily               => 'Debian',
      }
    end
    it { should include_class('postfix::params') }
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
    describe 'with remove_sendmail => true' do
      let :params do
        { :remove_sendmail => true }
      end
      it { should contain_service('sendmail').with_ensure('stopped') }
      it { should contain_package('sendmail').with_ensure('absent') }
    end
  end
end
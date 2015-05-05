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

      describe 'with remove_sendmail => true' do
        let :params do
          { :remove_sendmail => true }
        end
        it { should contain_service(os['expectations']['sendmail_service']).with_ensure('stopped') }
        it { should contain_package(os['expectations']['sendmail_package']).with_ensure(os['expectations']['sendmail_ensure']) }
        it { should contain_package(os['expectations']['sendmailcf_package']).with_ensure(os['expectations']['sendmail_ensure']) }
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

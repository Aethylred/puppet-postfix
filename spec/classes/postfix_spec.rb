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
    it { should contain_augeas('postfix_config') }
      
    describe 'working with the default main.cf' do
      describe_augeas 'postfix_config', :target => 'etc/postfix/main.cf' do
        it { should_not execute.with_change }
      end
    end
    
    describe 'working with a modified main.cf' do
      describe_augeas 'postfix_config', :lens => 'Postfix_Main.lns', :target => 'etc/postfix/main.cf', :fixture => 'etc/postfix/main.modified.cf' do
        it { should execute.with_change }
        it 'should not match myorigin' do
          should_not aug_get('myorigin')
        end
        it 'should not match relayhost' do
          should_not aug_get('relayhost')
        end
        it { should execute.idempotently }
      end
    end
    
    describe 'with myorigin => example.org and the default main.cf' do
      let :params do
        { :myorigin => 'example.org' }
      end
      describe_augeas 'postfix_config', :lens => 'Postfix_Main.lns', :target => 'etc/postfix/main.cf' do
        it { should execute.with_change }
        it 'should match myorigin' do
          aug_get('myorigin').should == 'example.org'
        end
        it { should execute.idempotently }
      end
    end
    
    describe 'with myorigin => example.org and a modifies main.cf' do
      let :params do
        { :myorigin => 'example.org' }
      end
      describe_augeas 'postfix_config', :lens => 'Postfix_Main.lns', :target => 'etc/postfix/main.cf', :fixture => 'etc/postfix/main.modified.cf' do
        it { should execute.with_change }
        it 'should match myorigin' do
          aug_get('myorigin').should == 'example.org'
        end
        it { should execute.idempotently }
      end
    end
    
    describe 'with relayhost => smtp.example.org and the default main.cf' do
      let :params do
        { :relayhost => 'smtp.example.org' }
      end
      describe_augeas 'postfix_config', :lens => 'Postfix_Main.lns', :target => 'etc/postfix/main.cf' do
        it { should execute.with_change }
        it 'should match relayhost' do
          aug_get('relayhost').should == 'smtp.example.org'
        end
        it { should execute.idempotently }
      end
    end
    
    describe 'with relayhost => smtp.example.org and a modified main.cf' do
      let :params do
        { :relayhost => 'smtp.example.org' }
      end
      describe_augeas 'postfix_config', :lens => 'Postfix_Main.lns', :target => 'etc/postfix/main.cf', :fixture => 'etc/postfix/main.modified.cf' do
        it { should execute.with_change }
        it 'should match relayhost' do
          aug_get('relayhost').should == 'smtp.example.org'
        end
        it { should execute.idempotently }
      end
    end
    
    describe 'with relayhost => smtp.example.org, relayhost_port => 42 and the default main.cf' do
          let :params do
            { :relayhost      => 'smtp.example.org',
              :relayhost_port => '42',
            }
          end
          describe_augeas 'postfix_config', :lens => 'Postfix_Main.lns', :target => 'etc/postfix/main.cf' do
            it { should execute.with_change }
            it 'should match relayhost' do
              aug_get('relayhost').should == 'smtp.example.org:42'
            end
            it { should execute.idempotently }
          end
        end
        
        describe 'with relayhost => smtp.example.org, relayhost_port => 42 and a modified main.cf' do
          let :params do
            { :relayhost      => 'smtp.example.org',
              :relayhost_port => '42',
            }
          end
          describe_augeas 'postfix_config', :lens => 'Postfix_Main.lns', :target => 'etc/postfix/main.cf', :fixture => 'etc/postfix/main.modified.cf' do
            it { should execute.with_change }
            it 'should match relayhost' do
              aug_get('relayhost').should == 'smtp.example.org:42'
            end
            it { should execute.idempotently }
          end
        end
    
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
    it { should contain_augeas('postfix_config') }
      
    describe 'working with the default main.cf' do
      describe_augeas 'postfix_config', :target => 'etc/postfix/main.cf' do
        it { should_not execute.with_change }
      end
    end
    
    describe 'working with a modified main.cf' do
      describe_augeas 'postfix_config', :lens => 'Postfix_Main.lns', :target => 'etc/postfix/main.cf', :fixture => 'etc/postfix/main.modified.cf' do
        it { should execute.with_change }
        it 'should not match myorigin' do
          should_not aug_get('myorigin')
        end
        it 'should not match relayhost' do
          should_not aug_get('relayhost')
        end
        it { should execute.idempotently }
      end
    end
    
    describe 'with myorigin => example.org and the default main.cf' do
      let :params do
        { :myorigin => 'example.org' }
      end
      describe_augeas 'postfix_config', :lens => 'Postfix_Main.lns', :target => 'etc/postfix/main.cf' do
        it { should execute.with_change }
        it 'should match myorigin' do
          aug_get('myorigin').should == 'example.org'
        end
        it { should execute.idempotently }
      end
    end
    
    describe 'with myorigin => example.org and a modifies main.cf' do
      let :params do
        { :myorigin => 'example.org' }
      end
      describe_augeas 'postfix_config', :lens => 'Postfix_Main.lns', :target => 'etc/postfix/main.cf', :fixture => 'etc/postfix/main.modified.cf' do
        it { should execute.with_change }
        it 'should match myorigin' do
          aug_get('myorigin').should == 'example.org'
        end
        it { should execute.idempotently }
      end
    end
    
    describe 'with relayhost => smtp.example.org and the default main.cf' do
      let :params do
        { :relayhost => 'smtp.example.org' }
      end
      describe_augeas 'postfix_config', :lens => 'Postfix_Main.lns', :target => 'etc/postfix/main.cf' do
        it { should execute.with_change }
        it 'should match relayhost' do
          aug_get('relayhost').should == 'smtp.example.org'
        end
        it { should execute.idempotently }
      end
    end
    
    describe 'with relayhost => smtp.example.org and a modified main.cf' do
      let :params do
        { :relayhost => 'smtp.example.org' }
      end
      describe_augeas 'postfix_config', :lens => 'Postfix_Main.lns', :target => 'etc/postfix/main.cf', :fixture => 'etc/postfix/main.modified.cf' do
        it { should execute.with_change }
        it 'should match relayhost' do
          aug_get('relayhost').should == 'smtp.example.org'
        end
        it { should execute.idempotently }
      end
    end
    
    describe 'with relayhost => smtp.example.org, relayhost_port => 42 and the default main.cf' do
      let :params do
        { :relayhost      => 'smtp.example.org',
          :relayhost_port => '42',
        }
      end
      describe_augeas 'postfix_config', :lens => 'Postfix_Main.lns', :target => 'etc/postfix/main.cf' do
        it { should execute.with_change }
        it 'should match relayhost' do
          aug_get('relayhost').should == 'smtp.example.org:42'
        end
        it { should execute.idempotently }
      end
    end
    
    describe 'with relayhost => smtp.example.org, relayhost_port => 42 and a modified main.cf' do
      let :params do
        { :relayhost      => 'smtp.example.org',
          :relayhost_port => '42',
        }
      end
      describe_augeas 'postfix_config', :lens => 'Postfix_Main.lns', :target => 'etc/postfix/main.cf', :fixture => 'etc/postfix/main.modified.cf' do
        it { should execute.with_change }
        it 'should match relayhost' do
          aug_get('relayhost').should == 'smtp.example.org:42'
        end
        it { should execute.idempotently }
      end
    end
    
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

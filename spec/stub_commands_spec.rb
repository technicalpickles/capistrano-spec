require 'spec_helper'
require 'capistrano'

describe 'Command stubbing' do
  before do
    @configuration = Capistrano::Configuration.new
    @configuration.extend Capistrano::Spec::ConfigurationExtension
    @configuration.load do
      def remote_pwd
        capture 'pwd'
      end

      def remote_sudo_pwd
        capture 'pwd', :via => :sudo
      end

      def custom_pwd
        run 'pwd' do |ch, stream, data|
          return "#{stream}: #{data}"
        end
      end

      def no_block
      	run 'pwd'
      	nil
      end
    end
  end

  it 'should allow to stub command output' do
    @configuration.stub_command 'pwd', :data => '/stubded/path'
    @configuration.remote_pwd.should == '/stubded/path'
  end

  it 'should allow to stub sudo command output' do
    @configuration.stub_command "sudo -p 'sudo password: ' pwd", :data => '/stubbed/path'
    @configuration.remote_sudo_pwd.should == '/stubbed/path'
  end

  it 'should allow to stub custom command output' do
    @configuration.stub_command 'pwd', :data => '/stubbed/path'
    @configuration.custom_pwd.should == 'out: /stubbed/path'
  end

  it 'should allow to stub stream' do
    @configuration.stub_command 'pwd', :data => '/stubbed/path', :stream => :err
    @configuration.custom_pwd.should == 'err: /stubbed/path'
  end

  it 'should allow to stub commands without block' do
    @configuration.stub_command 'pwd'
    expect { @configuration.no_block }.to_not raise_error(NoMethodError)
  end

  it 'should allow to stub command processing' do
    @configuration.stub_command 'pwd', with: proc { |cmd| cmd }
    @configuration.remote_pwd.should == 'pwd'
  end

  it 'should allow to stub command processing (2)' do
  	testvar = false
    @configuration.stub_command 'pwd' do |cmd| testvar = true end
    @configuration.no_block
    testvar.should be_true
  end

  it 'should allow to stub command processing with error' do
    @configuration.stub_command 'pwd', raise: ::Capistrano::CommandError
    expect { @configuration.no_block }.to raise_error(::Capistrano::CommandError)
  end

  it 'should allow to stub command processing with CommandError' do
    @configuration.stub_command 'pwd', fail: true
    expect { @configuration.no_block }.to raise_error(::Capistrano::CommandError)
  end
end

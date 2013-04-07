require 'spec_helper'
require 'capistrano'

describe 'Capistrano has uploaded' do
  include Capistrano::Spec::Matchers

  before do
    @configuration = Capistrano::Configuration.new
    @configuration.extend Capistrano::Spec::ConfigurationExtension
    @configuration.load do
      def upload_from_to
        upload 'source.file', 'target.file'
      end

      def upload_to
        upload 'temp.XC3PO.file', 'target.file' # E.g. uploading generated tar
      end

      def upload_from
        upload 'source.file', 'temp.XC3PO.file' # E.g. uploading to temp file
      end
    end
  end

  it 'some file' do
    @configuration.upload 'source.file', 'target.file'
    @configuration.should have_uploaded
  end

  it 'a specific file to a specific location' do
    @configuration.upload_from_to
    @configuration.should have_uploaded('source.file').to('target.file')
  end

  it 'a specific file to some location' do
    @configuration.upload_from
    @configuration.should have_uploaded('source.file')
  end

  it 'some file to a specific location' do
    @configuration.upload_to
    @configuration.should have_uploaded.to('target.file')
  end
end

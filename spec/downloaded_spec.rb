require 'spec_helper'
require 'capistrano'

describe 'Capistrano has downloaded' do
  include Capistrano::Spec::Matchers

  before do
    @configuration = Capistrano::Configuration.new
    @configuration.extend Capistrano::Spec::ConfigurationExtension
    @configuration.load do
      def download_from_to
        download 'source.file', 'target.file'
      end

      def download_to
        download 'temp.XC3PO.file', 'target.file' # E.g. downloading generated tar
      end

      def download_from
        download 'source.file', 'temp.XC3PO.file' # E.g. downloading to temp file
      end
    end
  end

  subject(:configuration) { @configuration }

  it 'some file' do
    configuration.download 'source.file', 'target.file'

    expect(configuration).to have_downloaded
  end

  it 'a specific file from a specific location' do
    configuration.download_from_to

    expect(configuration).to have_downloaded('target.file').from('source.file')
  end

  it 'a specific file to some location' do
    configuration.download_from

    expect(configuration).to have_downloaded.from('source.file')
  end

  it 'some file to a specific location' do
    configuration.download_to

    expect(configuration).to have_downloaded('target.file')
  end
end

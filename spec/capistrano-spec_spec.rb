require 'spec_helper'
require 'capistrano'

require File.expand_path('../recipe/fakerecipe', __FILE__)

describe Capistrano::Spec do

  before do
    @configuration = Capistrano::Configuration.new
    @configuration.extend(Capistrano::Spec::ConfigurationExtension)
    @configuration.extend(Capistrano::Fakerecipe)
    Capistrano::Fakerecipe.load_into(@configuration)
  end

  subject(:fake_recipe) { @configuration }

  describe 'have_run' do

    it "will not raise error when run is in recipe" do
      fake_recipe.find_and_execute_task('fake:thing')
      expect{ should have_run("do some stuff")}.to_not raise_error(RSpec::Expectations::ExpectationNotMetError, /expected configuration to run .*\s*, but did not/)
    end

    it "will raise error when run not in recipe" do
      fake_recipe.find_and_execute_task('fake:thing')
      expect{ should have_run("don't find me")}.to raise_error(RSpec::Expectations::ExpectationNotMetError, /expected configuration to run .*\s*, but did not/)
    end

  end

  describe 'have_uploaded' do

    it "will not raise error when upload is in recipe" do
      fake_recipe.find_and_execute_task('fake:thing')
      expect{ should have_uploaded('foo').to('/tmp/foo')}.to_not raise_error(RSpec::Expectations::ExpectationNotMetError, /expected configuration to upload .*\s* to .*\s* but did not/)
    end

    it "will raise error when run upload not in recipe" do
      fake_recipe.find_and_execute_task('fake:thing')
      expect{ should have_uploaded('bar').to('/tmp/bar')}.to raise_error(RSpec::Expectations::ExpectationNotMetError, /expected configuration to upload .*\s* to .*\s* but did not/)
    end
  end

  describe 'have_gotten' do
    it "will not raise error when get is in recipe" do
      fake_recipe.find_and_execute_task('fake:thing')
      expect{ should have_gotten('/tmp/baz').to('baz')}.to_not raise_error(RSpec::Expectations::ExpectationNotMetError, /expected configuration to get .*\s* to .*\s* but did not/)
    end

    it "will raise error when get not in recipe" do
      fake_recipe.find_and_execute_task('fake:thing')
      expect{ should have_gotten('/tmp/blegga').to('blegga')}.to raise_error(RSpec::Expectations::ExpectationNotMetError, /expected configuration to get .*\s* to .*\s* but did not/)
    end
  end

  describe 'callback' do

    it "will not raise error when `before` callback has occured" do
      expect{ should callback('fake:thing').before('fake:stuff_and_things')}.to_not raise_error(RSpec::Expectations::ExpectationNotMetError, /expected configuration to callback .*\s* before .*\s*, but did not/)
    end

    it "will not raise error when `after` callback has occured" do
      expect{ should callback('fake:other_thing').after('fake:thing')}.to_not raise_error(RSpec::Expectations::ExpectationNotMetError, /expected configuration to callback .*\s* after .*\s*, but did not/)
    end
  end

end

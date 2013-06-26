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
    context 'before callbacks' do
      ['fake:before_this_execute_thing',
       'fake:before_this_also_execute_thing',
       'outside:undefined_task'].each do |task|
        it "will not raise error when `before` callback has occured for #{task}" do
          expect do
            should callback('fake:thing').before(task)
          end.to_not raise_error(
            RSpec::Expectations::ExpectationNotMetError,
            /expected configuration to callback .*\s* before .*\s*, but did not/
          )
        end
      end

      ['undefined_task', 'fake:before_this_dont_execute_thing'].each do |task|
        it "will raise error when `before` callback hasn't occured for '#{task}'" do
          expect do
            should_not callback('fake:thing').before(task)
          end.to_not raise_error(
            RSpec::Expectations::ExpectationNotMetError,
            /expected configuration to not callback .*\s* before .*\s*, but did/
          )
        end
      end
    end

    context 'after callbacks' do
      ['fake:after_this_execute_thing',
       'fake:after_this_also_execute_thing',
       'outside:undefined_task'].each do |task|
        it "will not raise error when `after` callback has occured for #{task}" do
          expect do
            should callback('fake:thing').after(task)
          end.to_not raise_error(
            RSpec::Expectations::ExpectationNotMetError,
            /expected configuration to callback .*\s* after .*\s*, but did not/
          )
        end
      end

      ['undefined_task', 'fake:after_this_dont_execute_thing'].each do |task|
        it "will raise error when `after` callback hasn't occured for '#{task}'" do
          expect do
            should_not callback('fake:thing').after(task)
          end.to_not raise_error(
            RSpec::Expectations::ExpectationNotMetError,
            /expected configuration to not callback .*\s* after .*\s*, but did/
          )
        end
      end
    end
  end

  describe 'have_put' do
    context 'when a path is given' do
      it "will not raise error when put is in recipe" do
        fake_recipe.find_and_execute_task('fake:thing')
        expect do
          should have_put('fake content').to('/tmp/put')
        end.to_not raise_error(RSpec::Expectations::ExpectationNotMetError, /expected configuration to put .*\s* to .*\s*, but did not/)
      end

      it "will raise error when put is not in recipe" do
        fake_recipe.find_and_execute_task('fake:thing')
        expect do
          should have_put('real content').to('/tmp/wherever')
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError, /expected configuration to put .*\s* to .*\s*, but did not/)
      end
    end

    context 'when a path is not given' do
      it "will not raise error when put is in recipe" do
        fake_recipe.find_and_execute_task('fake:thing')
        expect do
          should have_put('fake content')
        end.to_not raise_error(RSpec::Expectations::ExpectationNotMetError, /expected configuration to put .*\s*, but did not/)
      end

      it "will raise error when put is not in recipe" do
        fake_recipe.find_and_execute_task('fake:thing')
        expect do
          should have_put('real content')
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError, /expected configuration to put .*\s*, but did not/)
      end
    end
  end

end

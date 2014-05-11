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

  describe 'have_run_locally' do

    it "will not raise error when run_locally is in recipe" do
      fake_recipe.find_and_execute_task('fake:thing')
      expect{ should have_run_locally("do some stuff locally")}.to_not raise_error(RSpec::Expectations::ExpectationNotMetError, /expected configuration to run .*\s* locally, but did not/)
    end

    it "will raise error when run_locally not in recipe" do
      fake_recipe.find_and_execute_task('fake:thing')
      expect{ should have_run_locally("don't find me")}.to raise_error(RSpec::Expectations::ExpectationNotMetError, /expected configuration to run .*\s* locally, but did not/)
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

  describe 'have_downloaded' do
    let(:error_message) do
      /expected configuration to download .*\s* from .*\s* but did not/
    end

    before do
      fake_recipe.find_and_execute_task('fake:thing')
    end

    it "will not raise error when download is in recipe" do
      expect {
        expect(fake_recipe).to have_downloaded('foo').from('/tmp/foo')
      }.to_not raise_error(RSpec::Expectations::ExpectationNotMetError, error_message)
    end

    it "will raise error when run download not in recipe" do
      expect {
        expect(fake_recipe).to have_downloaded('bar').from('/tmp/bar')
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, error_message)
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
      it_should_behave_like 'correct before callback' do
        let(:task_name) { 'fake:before_this_execute_thing' }
      end

      it_should_behave_like 'correct before callback' do
        let(:task_name) { 'fake:before_this_also_execute_thing' }
      end

      it_should_behave_like 'correct before callback' do
        let(:task_name) { 'outside:undefined_task' }
      end

      it_should_behave_like 'incorrect before callback' do
        let(:task_name) { 'undefined_task' }
      end

      it_should_behave_like 'incorrect before callback' do
        let(:task_name) { 'fake:before_this_dont_execute_thing' }
      end
    end

    context 'after callbacks' do
      it_should_behave_like 'correct after callback' do
        let(:task_name) { 'fake:after_this_execute_thing' }
      end

      it_should_behave_like 'correct after callback' do
        let(:task_name) { 'fake:after_this_also_execute_thing' }
      end

      it_should_behave_like 'correct after callback' do
        let(:task_name) { 'outside:undefined_task' }
      end

      it_should_behave_like 'incorrect after callback' do
        let(:task_name) { 'undefined_task' }
      end

      it_should_behave_like 'incorrect after callback' do
        let(:task_name) { 'fake:after_this_dont_execute_thing' }
      end
    end
  end

  describe 'have_put' do
    context 'when a path is given' do
      it "will not raise error when put is in recipe" do
        fake_recipe.find_and_execute_task('fake:thing')
        expect do
          should have_put('fake content').to('/tmp/put')
        end.to_not raise_error(
          RSpec::Expectations::ExpectationNotMetError,
          /expected configuration to put .*\s* to .*\s*, but did not/
        )
      end

      it "will raise error when put is not in recipe" do
        fake_recipe.find_and_execute_task('fake:thing')
        expect do
          should have_put('real content').to('/tmp/wherever')
        end.to raise_error(
          RSpec::Expectations::ExpectationNotMetError,
          /expected configuration to put .*\s* to .*\s*, but did not/
        )
      end
    end

    context 'when a path is not given' do
      it "will not raise error when put is in recipe" do
        fake_recipe.find_and_execute_task('fake:thing')
        expect do
          should have_put('fake content')
        end.to_not raise_error(
          RSpec::Expectations::ExpectationNotMetError,
          /expected configuration to put .*\s*, but did not/
        )
      end

      it "will raise error when put is not in recipe" do
        fake_recipe.find_and_execute_task('fake:thing')
        expect do
          should have_put('real content')
        end.to raise_error(
          RSpec::Expectations::ExpectationNotMetError,
          /expected configuration to put .*\s*, but did not/
        )
      end
    end
  end

end

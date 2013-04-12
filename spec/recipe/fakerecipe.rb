require 'capistrano'
  module Capistrano
    module Fakerecipe
      def self.load_into(configuration)
        configuration.load do
          before "fake:stuff_and_things", "fake:thing"
          after "fake:thing", "fake:other_thing"
          namespace :fake do
            desc "thing and run fake manifests"
            task :thing do
              set :bar, "baz"
              run('do some stuff')
              upload("foo", "/tmp/foo")
              get('/tmp/baz', 'baz')
            end
            desc "More fake tasks!"
            task :other_thing do
              #
            end
            desc "You get the picture..."
            task :stuff_and_things do
              #
            end
          end
        end
      end
    end
  end

  if Capistrano::Configuration.instance
    Capistrano::FakeRecipe.load_into(Capistrano::Configuration.instance)
  end
require "bundler/gem_tasks"

namespace :rspec do

  desc "Runs all RSpec specs"
  task :all do
    set_environment("TEST")
    run_all_specs
  end

  def set_environment(environment)
    ENV["ENVIRONMENT"] = environment
  end

  def run_all_specs
    system("rspec")
  end

end

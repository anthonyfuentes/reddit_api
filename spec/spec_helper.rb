require "bundler/setup"
Bundler.setup
require "vcr"
require "reddit_api"

RSpec.configure do |config|
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

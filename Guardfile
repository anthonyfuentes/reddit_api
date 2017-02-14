
guard :rspec, cmd: "bundle exec rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  watch(%r{^lib/reddit_api/(.+)\.rb$}) do |m|
    "spec/#{m[1]}_spec.rb"
  end
  dsl.watch_spec_files_for(ruby.lib_files)

end

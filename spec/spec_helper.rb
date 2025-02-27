# spec/spec_helper.rb
require "bundler/setup"
require "simplecov"
require "awslogs"
require "pry"

# Require all necessary files from the lib directory
Dir[File.join(__dir__, "..", "lib", "**", "*")].each do |file|
  require file if File.file?(file)
end

SimpleCov.start do
  add_filter "spec/"
  add_filter ".github/"
end

RSpec.configure do |config|
  # Optional: enable flags like :focus or :order if you are using rspec-core
  # config.example_status_persistence_file_path = "spec/examples.txt"
end

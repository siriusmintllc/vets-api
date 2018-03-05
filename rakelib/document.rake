# frozen_string_literal: true
require 'documentation/generator'

desc 'Given user attributes, run a find candidate query'
task document: :environment do
  puts "generating document from spec..."
  command = "bundle exec rspec spec/request/#{ENV['spec']}"
  puts Documentation::Generator.instance.inspect
  system(command)
end

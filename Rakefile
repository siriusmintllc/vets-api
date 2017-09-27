# frozen_string_literal: true
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

# Load rake support files
Dir[Rails.root.join('lib/tasks/support/**/*.rb')].each { |f| require f }

Rails.application.load_tasks

Rake.application.instance_eval do
  # remove test:prepare from prerequisites for benchmark and profile jobs
  # see: https://github.com/rails/rails-perftest/issues/24
  @tasks['test:benchmark'].prerequisites.shift if @tasks['test:benchmark']
  @tasks['test:profile'].prerequisites.shift if @tasks['test:profile']
end

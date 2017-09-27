# frozen_string_literal: true
ENV['RAILS_ENV'] = 'benchmark'
$VERBOSE = nil
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'rails/performance_test_help'

class ActionDispatch::PerformanceTest
  self.profile_options = { runs: 5, metrics: [:wall_time, :process_time, :objects, :gc_runs, :gc_time],
                           output: 'tmp/performance', formats: [:flat, :graph_html, :call_tree, :call_stack] }
end

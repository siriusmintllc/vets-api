# frozen_string_literal: true
require './test/benchmark_helper'
require 'rails/performance_test_help'

class Sessions < ActionDispatch::PerformanceTest
  test 'homepage' do
    get '/'
  end

  test 'new_loa1_session' do
    get '/v0/sessions/new?level=1'
  end
end

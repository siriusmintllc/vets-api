# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'JSON::Validator "strict" mode', type: :request do

  include SchemaMatchers

  it 'should pass when the properties match exactly' do

    tester = {
      alpha: 'foo',
      beta: 'foo'
    }

    schema_path = Rails.root.join('spec', 'support', 'schemas', "bugtest.json")
    valid = JSON::Validator.validate!(schema_path.to_s, tester, { strict: true })

    expect(valid).to eq(true)

  end


  it 'should fail when a property in the schema is missing' do

    tester = {
      alpha: 'foo'
    }

    schema_path = Rails.root.join('spec', 'support', 'schemas', "bugtest.json")
    expect{
      JSON::Validator.validate!(schema_path.to_s, tester, { strict: true })
    }.to raise_error(StandardError)

  end


  it 'should fail when an extra property (not in the schema) is present' do

    tester = {
      alpha: 'foo',
      beta: 'foo',
      gamma: 'foo'
    }

    schema_path = Rails.root.join('spec', 'support', 'schemas', "bugtest.json")
    expect{
      JSON::Validator.validate!(schema_path.to_s, tester, { strict: true })
    }.to raise_error(StandardError)

  end
end

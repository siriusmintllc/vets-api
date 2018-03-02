# frozen_string_literal: true
require 'singleton'

module RSpec
  module Rails
    module Matchers
      class EndpointSpecification

        def initialize(status, request, response)
          @status = status
          @request = request
          @response = response
        end

        def matches?(response)
          @response = response
          result = matches_http_status_code? && matches_schema?
          document_endpoint if result
        end

        def with_schema(schema_filename, opts = {})
          @schema_path = ::Rails.root.join('spec', 'support', 'schemas', "#{schema_filename}.json")
          @opts = opts
          self
        end

        private

        def matches_http_status_code?
          raise ArgumentError, "Invalid HTTP status: nil" unless @status
          matcher = HaveHttpStatus.matcher_for_status(@status)
          result = matcher.matches? @response
          @failure_message = matcher.failure_message unless result
          result
        end

        def matches_schema?
          json = @response.body
          JSON::Validator.validate!(@schema_path.to_s, json, { strict: true }.merge(@opts))
        rescue => e
          @failure_message = e.message
          false
        end

        def failure_message
          @failure_message
        end

        def document_endpoint
          schema_file = File.open(@schema_path, 'rb')
          Documenter.instance.document_response(
            method: @request.env['REQUEST_METHOD'].downcase.to_s,
            path: @request.env['PATH_INFO'],
            status: @response.status,
            body: @response.body,
            schema: schema_file.read
          )
          schema_file.close
          puts Documenter.instance.inspect
        end
      end

      def document(method, path, heading: nil, description: nil)
        Documenter.instance.add_resource(method, path, heading, description)
      end

      def document_status(status)
        EndpointSpecification.new(status, request, response)
      end
    end
  end
end

class Documenter
  include Singleton

  def initialize
    @resources = {}
  end

  def add_resource(method, path, heading, description)
    raise 'resource already defined!' if @resources.has_key? [method, path]
    @resources[[method, path]] = { heading: heading, description: description }
  end

  def document_response(method:, path:, status:, body:, schema:)
    resource = @resources[[method, path]]
    resource.add_response(status, body, schema)
  end
end

class Resource
  attr_accessor :heading, :description, :responses

  def initialize(heading, description)
    @heading = heading
    @description = description
    @responses = {}
  end

  def add_response(status, body, schema)
    @responses << Response.new(status, body, schema)
  end
end

class Response
  attr_accessor :status, :body, :schema
end

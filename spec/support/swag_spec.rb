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
          result
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
          return unless ENV['spec']
          puts "ENV #{ENV['spec'].inspect}"
          schema_file = File.open(@schema_path, 'rb')
          Documentation::Generator.instance.add_response(
            method: @request.env['REQUEST_METHOD'].downcase.to_sym,
            path: @request.env['PATH_INFO'],
            status: @response.status,
            body: @response.body,
            schema: schema_file.read
          )
        end
      end

      def document(method, path, description: nil)
        return unless ENV['spec']
        Documentation::Generator.instance.add_resource(method, path, description)
      end

      def document_status(status)
        EndpointSpecification.new(status, request, response)
      end
    end
  end
end

# frozen_string_literal: true

module Documentation
  class Generator
    include Singleton

    def initialize
      @resources = {}
    end

    def add_resource(method, path, description)
      raise 'resource already defined!' if @resources.has_key? [method, path]
      @resources[[method, path]] = Documentation::Resource.new(method, path, description)
    end

    def add_response(method:, path:, status:, body:, schema:)
      resource = @resources[[method, path]]
      resource.add_response(status, body, schema)
    end

    def generate(spec)
      name = spec.split('_request_spec.rb').first
      File.open(Rails.root.join('docs', 'api', 'blueprint', "#{name}.md"), 'w') do |f|
        f.puts "# #{name.capitalize}\n\n"
        @resources.each do |_k, resource|
          f.puts "## #{resource.method} #{resource.path}\n\n"
          f.puts "#{resource.description}\n\n"
          resource.responses.each do |response|
            f.puts "+ Response #{response.status}\n\n"
            f.puts "    + Body\n\n"
            f.puts JSON.pretty_generate(
              JSON.parse(response.body), {indent: "    "}
            ).lines.map { |line| "        #{line}" }
          end
        end
      end
    end
  end

  class Resource
    attr_accessor :method, :path, :description, :responses

    def initialize(method, path, description)
      @method = method.upcase
      @path = path
      @description = description
      @responses = []
    end

    def add_response(status, body, schema)
      @responses << Documentation::Response.new(status, body, schema)
    end
  end

  class Response
    attr_accessor :status, :body, :schema

    def initialize(status, body, schema)
      @status = status
      @body = body
      @schema = schema
    end
  end
end

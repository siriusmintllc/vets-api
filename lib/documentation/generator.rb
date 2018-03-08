# frozen_string_literal: true

class Hash
  def find_all_values_for(key)
    result = []
    result << self[key]
    self.values.each do |hash_value|
      values = [hash_value] unless hash_value.is_a? Array
      values&.each do |value|
        result += value.find_all_values_for(key) if value.is_a? Hash
      end
    end
    result.compact
  end
end

module Documentation
  class Generator
    include Singleton

    def initialize
      @resources = {}
    end

    def add_resource(method, path, description)
      return if @resources.has_key? [method, path]
      @resources[[method, path]] = Documentation::Resource.new(method, path, description)
      puts @resources
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
          f.puts "+ Parameters"
          f.puts "    + post_id: `1` (string) - The id of the Post.\n\n"
          print_responses(f, resource)
        end
      end
    end

    private

    def print_responses(f, resource)
      resource.responses.each do |response|
        f.puts "+ Response #{response.status}\n\n"
        f.puts "    + Body\n\n"
        f.puts print_indented(response.body)
        f.puts "\n"
        f.puts "    + Schema\n\n"
        f.puts print_indented(response.schema)
        print_schema_refs(f, response)
      end
    end

    def print_schema_refs(f, response)
      response.schema_refs.each do |ref|
        path = ::Rails.root.join('spec', 'support', 'schemas', ref)
        schema_file = File.open(path, 'rb')
        f.puts print_indented(schema_file.read)
      end
    end

    def print_indented(json)
      h = JSON.parse(json)
      puts h.find_all_values_for('$ref').inspect
      JSON.pretty_generate(
        h, { indent: "    " }
      ).lines.map { |line| "            #{line}" }
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
    attr_accessor :status, :body, :schema, :schema_refs

    def initialize(status, body, schema)
      @status = status
      @body = body
      @schema = schema
      @schema_refs = []

      find_schema_refs
    end

    def find_schema_refs
      h = JSON.parse(@schema)
      @schema_refs = h.find_all_values_for('$ref').uniq
    end
  end
end

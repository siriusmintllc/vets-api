# module RSpec
#   module Docs
#     module Syntax
#
#     end
#   end
# end

class EndpointDocumenter
  # singleton
end

class RequestDocumenter
  def with_schema(schema_path)
    puts schema_path
  end
end

::RSpec::Mocks::ExampleMethods.class_exec do
  def document(status)
    puts status
    puts request.inspect
    puts response.inspect
    Documenter.new
  end
end

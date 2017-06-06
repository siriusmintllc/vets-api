# frozen_string_literal: true
class MockService
  def initialize(config)
    @definitions = YAML.load_file(config)
  end

  def mock
    @definitions.each do |k|
      klass = Object.const_get(k[:class])
      klass.class_eval do
        k[:methods].each do |method|
          name = method[:name]
          data_path = method[:data_path]

          define_method "#{name}_data" do
            data = instance_variable_get("@#{name}_data")
            return data if data
            instance_variable_set("@#{name}_data", YAML.load_file(data_path))
          end

          args = method[:args]

          define_method name do
            dig_args = [name]
            (dig_args << args).flatten! if args
            self.send("#{name}_data").dig(*dig_args)
          end
        end
      end
    end
  end
end

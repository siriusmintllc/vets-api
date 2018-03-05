# frozen_string_literal: true

module Documentation
  module AfterHook
    def self.included(base)
      return unless ENV['spec']

      base.after(:all) do
        Documentation::Generator.instance.generate(ENV['spec'])
      end
    end
  end
end

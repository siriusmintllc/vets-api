# frozen_string_literal: true
module MVI
  class StubConfiguration < Configuration
    def connection
      Faraday::Connection.new do |conn|
        conn.use Faraday::Adapter::Test do |stub|
          stub.post '' do |env|
            ssn = extract_ssn_from_env(env)
            template = template_for_user(ssn)
            [200, {}, template]
          end
        end
        conn.response :soap_parser
      end
    end

    private

    def extract_ssn_from_env(env)
      path = 'env:Body/idm:PRPA_IN201305UV02/controlActProcess/queryByParameter/parameterList/livingSubjectId/value'
      Ox.load(env.body).locate(path).first.attributes[:extension]
    end

    def template_for_user(ssn)
      yaml = YAML.load_file(Rails.root.join('config', 'mvi_schema', 'mock_mvi_responses.yml'))
      user = yaml.dig('find_candidate', ssn)
      xml = File.read(Rails.root.join('config', 'mvi_schema', 'find_profile_template.xml'))
      template = Liquid::Template.parse(xml)
      template.render(ActiveSupport::HashWithIndifferentAccess.new(user))
    end
  end
end

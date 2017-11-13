# frozen_string_literal: true

module IdentityService
  class SAMLResponseError < StandardError; end

  class Callback
    def initialize(saml_params)
      @saml_response = SAML::Response.new(saml_params, settings: SAML::SettingsService.saml_settings)
      raise SAMLResponseError unless @saml_response.valid?
      yield if block_given?
    end
  end
end

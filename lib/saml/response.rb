# frozen_string_literal: true
module SAML
  class Response < OneLogin::RubySaml::Response
    def authn_context
      REXML::XPath.first(saml_response.decrypted_document, '//saml:AuthnContextClassRef')&.text
    end
  end
end

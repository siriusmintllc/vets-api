# frozen_string_literal: true

module IdentityService
  class Login
    attr_reader :current_user, :session

    def initialize(saml_response)
      raise ArgumentError,
        'Argument is not a OneLogin::RubySaml::Response' unless saml_response.is_a?(SAML::Response)
      raise StandardError,
        'SAML Response must be valid' unless saml_response.valid?
      @saml_user = SAML::User.new(saml_response)
      @user = User.new(@saml_user.to_hash)
      @session = Session.new(uuid: user.uuid)
      yield if block_given && persist!
    end

    def existing_user
      User.find(@session.uuid)
    end

    def persist!
      @current_user =
        # Completely new signin, both session and current user will be persisted
        if existing_user.nil?
          StatsD.increment(STATSD_LOGIN_NEW_USER_KEY)
          new_user_from_saml
        # Existing user. Updated attributes as a result of enabling multifactor
        elsif saml_user.changing_multifactor?
          existing_user.multifactor = saml_user.decorated.multifactor
          existing_user
        # Existing user. Updated attributes as a result of completing identity proof
        else
          User.from_merged_attrs(existing_user, new_user_from_saml)
        end

      @session.save && @current_user.save
    end
  end
end

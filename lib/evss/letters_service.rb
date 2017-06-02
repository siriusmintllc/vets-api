# frozen_string_literal: true
require 'evss/base_service'
require 'common/exceptions/internal/parameter_missing'

module EVSS
  class LettersService < BaseService
    BASE_URL = "#{Settings.evss.url}/wss-lettergenerator-services-web/rest/letters/v1"

    def letters_for_user
      get ''
    end

    def letter_for_user_by_type(type)
      get type
    end

    def self.breakers_service
      BaseService.create_breakers_service(name: 'EVSS/Letters', url: BASE_URL)
    end
  end
end

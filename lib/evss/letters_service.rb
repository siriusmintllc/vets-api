# frozen_string_literal: true
require 'evss/base_service'

module EVSS
  class LettersService < BaseService
    BASE_URL = 'https://csraciapp6.evss.srarad.com/wss-lettergenerator-services-web/rest/letters/v1'

    def letters
      get 'https://csraciapp6.evss.srarad.com/wss-lettergenerator-services-web/rest/letters/v1'
    end

    def letter_by_type(type)
      get "/#{type}"
    end

    def self.breakers_service
      BaseService.create_breakers_service(name: 'EVSS/Letters', url: BASE_URL)
    end
  end
end

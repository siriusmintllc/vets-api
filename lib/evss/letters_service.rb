# frozen_string_literal: true
require 'evss/base_service'

module EVSS
  class LettersService < BaseService
    BASE_URL = Settings.evss.url

    def letters_for_user
      get 'letters/v1'
    end

    def self.breakers_service
      BaseService.create_breakers_service(name: 'EVSS/Letters', url: BASE_URL)
    end
  end
end

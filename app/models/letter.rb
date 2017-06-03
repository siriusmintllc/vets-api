# frozen_string_literal: true
require 'common/models/base'

class Letter < Common::Base
  LETTER_TYPES = %w(
    benefit_summary
    benefits_summary_dependent
    benefit_verification
    civil_service
    commissary
    proof_of_service
    service_verification
    medicare_partd
    minimum_essential_coverage
  )

  # TODO(AJD): make letters service inherit common client
  LETTER_SERVICE = EVSS::LettersService.new

  attribute :letter_name, String
  attribute :letter_type, String

  def self.all_for_user(user)
    response = LETTER_SERVICE.letters_for_user(user)
    letter_response = LettersResponse.new(
      address: response.body['letter_destination'],
      letters: response.body['letters']
    )
    letter_response
  end

  def self.download_type_for_user(type, user)

  end

  def initialize(init_attributes)
    raise ArgumentError, 'letter_name and letter_type are required' if init_attributes.values.any?(&:nil?)
    raise ArgumentError, 'invalid letter type' unless LETTER_TYPES.include? init_attributes['letter_type']
    super(init_attributes)
  end
end

class LetterAddress
  include Virtus.model

  attribute :full_name, String
  attribute :street1, String
  attribute :street2, String
  attribute :street3, String
  attribute :city, String
  attribute :state, String
  attribute :country, String
  attribute :foreign_code, String
  attribute :zip_code, String
end

class LettersResponse
  include Virtus.model

  attribute :address, LetterAddress
  attribute :letters, Array[Letter]
end

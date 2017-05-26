# frozen_string_literal: true
require 'rails_helper'
require 'evss/claims_service'
require 'evss/auth_headers'

describe EVSS::LettersService do
  let(:current_user) { FactoryGirl.create(:loa3_user) }
  let(:auth_headers) do
    EVSS::AuthHeaders.new(current_user).to_h
  end

  subject { described_class.new(auth_headers) }

  context 'with headers' do
    let(:evss_id) { 189_625 }

    it 'should get all letters for the user' do
      VCR.use_cassette('evss/letters/letters') do
        response = subject.letters_for_user
        expect(response).to be_success
      end
    end
  end
end

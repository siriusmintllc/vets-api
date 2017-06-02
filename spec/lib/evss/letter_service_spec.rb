# frozen_string_literal: true
require 'rails_helper'
require 'evss/letters_service'
require 'evss/auth_headers'

describe EVSS::LettersService do
  let(:current_user) { FactoryGirl.create(:loa3_user) }
  let(:auth_headers) { EVSS::AuthHeaders.new(current_user).to_h }
  subject { described_class.new(auth_headers) }

  describe '#letters_for_user' do
    context 'with a valid response' do
      it 'should return a list of letters for the user' do
        VCR.use_cassette('evss/letters/letters_for_user') do
          response = subject.letters_for_user
          expect(response).to be_success
        end
      end
    end

    context 'with a missing vaafi header' do
      let(:auth_headers) do
        h = EVSS::AuthHeaders.new(current_user).to_h
        h.delete('va_eauth_dodedipnid')
        h
      end

      it 'should raise a parsing error' do
        VCR.use_cassette('evss/letters/letters_for_user_bad_header') do
          expect { subject.letters_for_user }.to raise_error(Faraday::ParsingError)
        end
      end
    end

    context 'with no connection' do
      it 'should raise a timeout error' do
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::TimeoutError)
        expect { subject.letters_for_user }.to raise_error(Faraday::TimeoutError)
      end
    end
  end
end

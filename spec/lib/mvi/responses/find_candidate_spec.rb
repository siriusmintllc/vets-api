# frozen_string_literal: true
require 'rails_helper'
require 'mvi/responses/find_candidate'

describe MVI::Responses::FindCandidate do
  context 'given a valid response' do
    let(:faraday_response) { instance_double('Faraday::Response') }
    let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_response.xml')) }
    let(:find_candidate_response) { MVI::Responses::FindCandidate.new(faraday_response) }
    let(:va_profile_complete) { build(:va_profile_complete) }

    before(:each) do
      allow(faraday_response).to receive(:body) { body }
    end

    describe '#invalid?' do
      it 'should return false' do
        expect(find_candidate_response.invalid?).to be_falsey
      end
    end

    describe '#failure?' do
      it 'should return false' do
        expect(find_candidate_response.failure?).to be_falsey
      end
    end

    describe '.body' do
      context 'with middle name and icn, mhv correlation ids' do
        it 'should filter the patient attributes the system is interested in' do
          expect(find_candidate_response.body).to have_deep_attributes(va_profile_complete)
        end
      end

      context 'when name parsing fails' do
        let(:va_profile_complete) { build(:va_profile_complete, given_names: nil, family_name: nil, suffix: nil) }
        it 'has nil name values' do
          allow(find_candidate_response).to receive(:get_patient_name).and_return(nil)
          expect(find_candidate_response.body.given_names).to eq([])
          expect(find_candidate_response.body.family_name).to be_nil
        end
      end

      context 'with a missing address' do
        let(:va_profile) { build(:va_profile, home_phone: '1112223333', suffix: 'Sr') }
        let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_response_nil_address.xml')) }
        it 'should set the address to nil' do
          expect(find_candidate_response.body).to have_deep_attributes(va_profile)
        end
      end
    end
  end

  context 'with no middle name, missing and alternate correlation ids, multiple other_ids' do
    let(:faraday_response) { instance_double('Faraday::Response') }
    let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_missing_attrs.xml')) }
    let(:find_candidate_missing_attrs) { MVI::Responses::FindCandidate.new(faraday_response) }
    let(:va_profile_mvi_response) { build(:va_profile_mvi_response, given_names: %w(Mitchell)) }

    describe '#body' do
      it 'should filter with only first name and retrieve correct MHV id' do
        allow(faraday_response).to receive(:body) { body }
        expect(find_candidate_missing_attrs.body).to have_deep_attributes(va_profile_mvi_response)
      end
    end
  end

  context 'with no subject element' do
    let(:faraday_response) { instance_double('Faraday::Response') }
    let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_no_subject.xml')) }
    let(:find_candidate_response_mhv_id) { MVI::Responses::FindCandidate.new(faraday_response) }

    describe '#body' do
      it 'return nil if the response includes no suject element' do
        allow(faraday_response).to receive(:body) { body }
        expect(find_candidate_response_mhv_id.body).to be_nil
      end
    end
  end

  context 'given an invalid response' do
    let(:faraday_response) { instance_double('Faraday::Response') }
    let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_invalid_response.xml')) }
    let(:find_candidate_invalid_response) { MVI::Responses::FindCandidate.new(faraday_response) }

    before(:each) do
      allow(faraday_response).to receive(:body) { body }
    end

    describe '#invalid?' do
      it 'should return true' do
        expect(find_candidate_invalid_response.invalid?).to be_truthy
      end
    end

    describe '#failure?' do
      it 'should return false' do
        expect(find_candidate_invalid_response.failure?).to be_falsey
      end
    end
  end

  context 'given a failure response' do
    context 'invalid registration identification' do
      let(:faraday_response) { instance_double('Faraday::Response') }
      let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_failure_response.xml')) }
      let(:find_candidate_failure_response) { MVI::Responses::FindCandidate.new(faraday_response) }

      before(:each) do
        allow(faraday_response).to receive(:body) { body }
      end

      describe '#invalid?' do
        it 'should return false' do
          expect(find_candidate_failure_response.invalid?).to be_falsey
        end
      end

      describe '#failure?' do
        it 'should return true' do
          expect(find_candidate_failure_response.failure?).to be_truthy
        end
      end

      describe '#multiple_match?' do
        it 'should return false' do
          expect(find_candidate_failure_response.multiple_match?).to be_falsey
        end
      end
    end
    context 'multiple match' do
      let(:faraday_response) { instance_double('Faraday::Response') }
      let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_multiple_match_response.xml')) }
      let(:find_candidate_multiple_response) { MVI::Responses::FindCandidate.new(faraday_response) }

      before(:each) do
        allow(faraday_response).to receive(:body) { body }
      end

      describe '#invalid?' do
        it 'should return false' do
          expect(find_candidate_multiple_response.invalid?).to be_falsey
        end
      end

      describe '#failure?' do
        it 'should return true' do
          expect(find_candidate_multiple_response.failure?).to be_truthy
        end
      end

      describe '#multiple_match?' do
        it 'should return true' do
          expect(find_candidate_multiple_response.multiple_match?).to be_truthy
        end
      end
    end
  end

  context 'with multiple MHV IDs' do
    let(:faraday_response) { instance_double('Faraday::Response') }
    let(:body) { Ox.parse(File.read('spec/support/mvi/find_candidate_multiple_mhv_response.xml')) }
    let(:find_candidate_multiple_mhvids) { MVI::Responses::FindCandidate.new(faraday_response) }
    let(:va_profile_mvi_mhvids) { build(:va_profile_mvi_mhvids) }

    before(:each) do
      allow(faraday_response).to receive(:body) { body }
    end

    it 'returns an array of mhv ids' do
      expect(find_candidate_multiple_mhvids.body).to have_deep_attributes(va_profile_mvi_mhvids)
    end
  end
end

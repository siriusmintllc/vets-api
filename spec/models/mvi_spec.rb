# frozen_string_literal: true
require 'rails_helper'
require 'common/exceptions'

describe Mvi, skip_mvi: true do
  let(:user) { FactoryGirl.build(:loa3_user) }
  let(:mvi) { Mvi.from_user(user) }
  let(:va_profile) { build(:va_profile) }

  describe '.from_user' do
    it 'creates an instance with user attributes' do
      expect(mvi.uuid).to eq(user.uuid)
      expect(mvi.user).to eq(user)
    end
  end

  describe '#query' do
    context 'when the cache is empty' do
      context 'with a succesful MVI response' do
        it 'should cache and return the response' do
          expect_any_instance_of(MVI::Service).to receive(:find_candidate).once.and_return(va_profile)
          expect(mvi.redis_namespace).to receive(:set).once.with(
            user.uuid,
            Oj.dump(
              uuid: user.uuid,
              response: va_profile
            )
          )
          expect(mvi.edipi).to eq(va_profile.edipi.split('^').first)
          expect(mvi.icn).to eq(va_profile.icn.split('^').first)
          expect(mvi.mhv_correlation_id).to eq(va_profile.mhv_ids.first.split('^').first)
          expect(mvi.participant_id).to eq(va_profile.vba_corp_id.split('^').first)
        end
      end

      context 'when a MVI::Errors::HTTPError is raised' do
        it 'should log an error message and return status server error' do
          allow_any_instance_of(MVI::Service).to receive(:find_candidate).and_raise(
            Common::Client::Errors::HTTPError.new('MVI HTTP call failed', 500)
          )
          expect(Rails.logger).to receive(:error).once.with(/MVI HTTP error code: 500 for user:/)
          expect { mvi.va_profile }.to raise_error(MVI::Errors::ServiceError)
        end
      end

      context 'when a MVI::Errors::ServiceError is raised' do
        it 'should log an error message and return status not found' do
          allow_any_instance_of(MVI::Service).to receive(:find_candidate).and_raise(MVI::Errors::InvalidRequestError)
          expect(Rails.logger).to receive(:error).once.with(
            /MVI service error: MVI::Errors::InvalidRequestError for user:/
          )
          expect { mvi.va_profile }.to raise_error(MVI::Errors::InvalidRequestError)
        end
      end

      context 'when MVI::Errors::RecordNotFound is raised' do
        it 'should log an error message and return status not found' do
          allow_any_instance_of(MVI::Service).to receive(:find_candidate).and_raise(
            MVI::Errors::RecordNotFound.new('not found')
          )
          expect(Rails.logger).to receive(:error).once.with(/MVI record not found for user:/)
          expect { mvi.va_profile }.to raise_error(MVI::Errors::RecordNotFound)
        end
      end
    end

    context 'when there is cached data' do
      it 'returns the cached data' do
        mvi.response = va_profile
        mvi.save
        expect_any_instance_of(MVI::Service).to_not receive(:find_candidate)
        expect(mvi.va_profile).to have_deep_attributes(va_profile)
      end
    end
  end

  context 'when all correlation ids have values' do
    before(:each) do
      allow_any_instance_of(MVI::Service).to receive(:find_candidate).and_return(find_candidate_response)
    end
  end

  around(&:run)
end

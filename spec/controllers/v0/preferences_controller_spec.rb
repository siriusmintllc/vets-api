# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V0::PreferencesController, type: :controller do
  describe '#show' do
    context 'when not logged in' do
      it 'returns unauthorized' do
        get :show
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when logged in as an LOA1 user' do
      let(:token) { 'abracadabra-open-sesame' }
      let(:auth_header) { ActionController::HttpAuthentication::Token.encode_credentials(token) }
      let(:loa1_user) { build(:user, :loa1) }
      let(:preference) { create(:preference_with_choices) }

      before(:each) do
        Session.create(uuid: loa1_user.uuid, token: token)
        User.create(loa1_user)
        request.env['HTTP_AUTHORIZATION'] = auth_header
      end

      it 'returns successful http status' do
        expect(response).to have_http_status(:success)
      end

      it 'returns a single Preference' do
        get :show, preference: preference.code

        preference_code = json_body['attributes']['code']
        expect(preference_code).to eq preference.code
      end

      it 'returns all PreferenceChoices for given Preference' do
        get :show, preference: preference.code
								preference_choices = json_body['attributes']['preference_choices']
        expect(preference_choices).to eq preference.choices
      end
    end
  end
end
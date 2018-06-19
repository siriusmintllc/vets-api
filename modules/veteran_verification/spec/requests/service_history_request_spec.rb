# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Service History API endpoint', type: :request, skip_emis: true do
  include SchemaMatchers

  let(:token) { 'fa0f28d6-224a-4015-a3b0-81e77de269f2' }
  let(:auth_header) { { 'Authorization' => "Token token=#{token}" } }
  let(:user) { build(:user, :loa3) }

  before do
    Session.create(uuid: user.uuid, token: token)
    User.create(user)
  end

  context 'with valid emis responses' do
    it 'should return the current users service history' do

      VCR.use_cassette('emis/get_deployment/valid') do
        VCR.use_cassette('emis/get_military_service_episodes/valid') do
          get '/services/veteran_verification/v0/service_history', nil, auth_header
          expect(response).to have_http_status(:ok)
          expect(response.body).to be_a(String)
          expect(response).to match_response_schema('service_and_deployment_history_response')
        end
      end
    end
  end
end

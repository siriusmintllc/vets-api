# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'in progress forms', type: :request do
  let(:token) { 'fa0f28d6-224a-4015-a3b0-81e77de269f2' }
  let(:auth_header) { { 'Authorization' => "Token token=#{token}" } }
  let(:user) { build(:loa3_user) }

  before do
    Session.create(uuid: user.uuid, token: token)
    User.create(user)
    allow(YAML).to receive(:load_file).and_return(
      'veteran_full_name' => %w(identity_information full_name),
      'gender' => %w(identity_information gender),
      'veteran_date_of_birth' => %w(identity_information date_of_birth),
      'veteran_address' => %w(contact_information address),
      'home_phone' => %w(contact_information home_phone)
    )
  end

  describe 'GET' do
    it 'should return a list of letters for the user' do
      get v0_letters_url, nil, auth_header
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST' do
    it 'should create a letter (PDF) and return it' do
      post v0_letters_url, nil, auth_header
      expect(response).to have_http_status(:ok)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HCASubmissionFailureMailer, type: [:mailer] do
  let(:email) { 'foo@example.com' }
  let(:google_analytics_client_id) { '123456543' }

  subject do
    described_class.build(email, google_analytics_client_id).deliver_now
  end

  describe '#build' do
    it 'should include all info' do
      expect(subject.subject).to eq("We can't process your health care application")
      expect(subject.to).to eq(['foo@example.com'])
      expect(subject.body.raw_source).to include(
        "We're sorry. Your health care application didn't go through because of a technical issue on our end."
      )
      expect(subject.body.raw_source).to include('cid=123456543')
    end
  end
end

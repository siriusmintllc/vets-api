# frozen_string_literal: true
require 'evss/letters_service'
require 'evss/auth_headers'

class EVSSLetterService
  def initialize(user)
    @user = user
  end

  def all
    response = client.letters_for_user
    puts response
  end

  def download_pdf(type)

  end

  private

  def client
    @client ||= EVSS::LettersService.new(auth_headers)
  end

  def auth_headers
    @auth_headers ||= EVSS::AuthHeaders.new(@user).to_h
  end
end

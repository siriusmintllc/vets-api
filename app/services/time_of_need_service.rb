# frozen_string_literal: true
require 'restforce'
require 'faraday'

class TimeOfNeedService

  @conn = Faraday.new(:url => Settings.timeOfNeed.faraday_url)

  @request = @conn.post do |req|
    req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
    req.body = Settings.timeOfNeed.client_secret+'&'+Settings.timeOfNneed.api_version+'&'+Settings.timeOfNneed.username+'&'+Settings.timeOfNeed.password+'&'+Settings.timeOfNeed.grant_type
  end

  @client = Restforce.new(oauth_token: JSON.parse(@request.body)["access_token"],
                         instance_url: Settings.timeOfNeed.instance_url,
                         api_version: Settings.timeOfNneed.api_version)

  def create(ton)
    client.create('Case', ton.as_json)
  end

  def read(id)
    client.find('Account', id)
  end

end
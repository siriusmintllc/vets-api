# frozen_string_literal: true
require 'restforce'
require 'faraday'

class TimeOfNeedService

  @conn = Faraday.new(:url => 'https://va--mbmssit.cs33.my.salesforce.com/services/oauth2/token')

  @request = @conn.post do |req|
    req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
    req.body = 'client_secret=6150175763295809569&client_id=3MVG9Zdl7Yn6QDKPHMwHadV4iFddvfNHNDYs18l_CHPw5JkdgIjR0trqqefjrP4jbfu5AHnCbxyEg60Tz3KWW&api_version=42.0&username=mbms_integration@bah.com.mbmssit&password=littlekyle2spCL3xcR7dbcUrrSwcgoUrDQ&grant_type=password'
  end

  @client = Restforce.new(oauth_token: JSON.parse(@request.body)["access_token"],
                         instance_url: 'https://va--MBMSSit.cs33.my.salesforce.com',
                         api_version: '42.0')

  def create(ton)
    client.create('Case', ton.as_json)
  end

  def read(id)
    client.find('Account', id)
  end

end
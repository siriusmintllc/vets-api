
require 'preneeds/service'

class TimeOfNeedController < ApplicationController
  skip_before_action(:authenticate)
  before_action(:tag_rainbows)

  protected

  def client
    # todo: add rest client
  end
end

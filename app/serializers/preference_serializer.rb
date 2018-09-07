# frozen_string_literal: true

class PreferenceSerializer < ActiveModel::Serializer
  attribute :code
  attribute :title
  attribute :preference_choices

  def id
    nil
  end

  delegate :preference_choices, to: :object
end

# frozen_string_literal: true

class PreferenceSerializer < ActiveModel::Serializer
  attribute :code
  attribute :title
  attribute :preference_choices

  def id
    nil
  end

  def preference_choices
    object.preference_choices
  end
end

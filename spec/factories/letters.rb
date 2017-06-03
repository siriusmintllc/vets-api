# frozen_string_literal: true
FactoryGirl.define do
  factory :letter, class: 'Letter' do
    letter_name 'Benefits Summary Letter'
    letter_type 'benefits_summary'
    initialize_with do
      args = { letter_name: letter_name, letter_type: letter_type }
      new(args)
    end
  end
end

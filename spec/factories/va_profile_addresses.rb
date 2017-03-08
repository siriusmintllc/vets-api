# frozen_string_literal: true
FactoryGirl.define do
  factory :va_profile_address, class: 'VaProfileAddress' do
    street '121 A St'
    city 'Austin'
    state 'TX'
    postal_code '78772'
    country 'USA'
  end

  factory :va_profile_address_2, class: 'VaProfileAddress' do
    street '42 MAIN ST'
    city 'SPRINGFIELD'
    state 'IL'
    postal_code '62722'
    country 'USA'
  end

  factory :va_profile_address_lincoln, class: 'VaProfileAddress' do
    street '140 Rock Creek Church Road NW'
    city 'Washington'
    state 'DC'
    postal_code '20011'
    country 'USA'
  end
end

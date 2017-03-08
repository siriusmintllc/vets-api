# frozen_string_literal: true
FactoryGirl.define do
  factory :va_profile, class: 'VaProfile' do
    given_names %w(John William)
    family_name 'Smith'
    suffix nil
    gender 'M'
    birth_date '19800101'
    ssn '555443333'
    address nil
    home_phone nil
    icn '1000123456V123456^NI^200M^USVHA^P'
    mhv_ids ['123456^PI^200MHV^USVHA^A']
    edipi '1234^NI^200DOD^USDOD^A'
    vba_corp_id '12345678^PI^200CORP^USVBA^A'

    factory :va_profile_complete do
      home_phone '1112223333'
      suffix 'Sr'
      after(:build) do |profile|
        profile.address = FactoryGirl.build(:va_profile_address)
      end
    end
  end

  factory :va_profile_mvi_response, class: 'VaProfile' do
    given_names %w(Mitchell G)
    family_name 'Jenkins'
    suffix nil
    gender 'M'
    birth_date '19490304'
    ssn '796122306'
    address nil
    home_phone nil
    icn '1008714701V416111^NI^200M^USVHA^P'
    mhv_ids ['1100792239^PI^200MHS^USVHA^A']
    vba_corp_id '9100792239^PI^200CORP^USVBA^A'
    after(:build) do |profile|
      profile.address = FactoryGirl.build(:va_profile_address)
    end
  end

  factory :va_profile_mvi_mhvids, class: 'VaProfile' do
    given_names %w(Steve A)
    family_name 'Ranger'
    suffix nil
    gender 'M'
    birth_date '19800101'
    ssn '111223333'
    address nil
    home_phone '1112223333 p1'
    icn '12345678901234567^NI^200M^USVHA^P'
    mhv_ids %w(12345678901^PI^200MH^USVHA^A 12345678902^PI^200MH^USVHA^A)
    edipi '1122334455^NI^200DOD^USDOD^A'
    vba_corp_id '12345678^PI^200CORP^USVBA^A'
    after(:build) do |profile|
      profile.address = FactoryGirl.build(:va_profile_address_2)
    end
  end

  factory :va_profile_lincoln, class: 'VaProfile' do
    birth_date '18090212'
    edipi '1234^NI^200DOD^USDOD^A'
    vba_corp_id '12345678^PI^200CORP^USVBA^A'
    family_name 'Lincoln'
    gender 'M'
    given_names %w(Abraham)
    icn '1000123456V123456^NI^200M^USVHA^P'
    mhv_ids ['123456^PI^200MH^USVHA^A']
    ssn '272111863'
    home_phone '2028290436'
    suffix nil
    after(:build) do |profile|
      profile.address = FactoryGirl.build(:va_profile_address_lincoln)
    end
  end
end

# frozen_string_literal: true
class VaProfileAddress
  include Virtus.model

  attribute :street, String
  attribute :city, String
  attribute :state, String
  attribute :postal_code, String
  attribute :country, String
end

class VaProfile
  include Virtus.model

  attribute :given_names, Array[String]
  attribute :family_name, String
  attribute :suffix, String
  attribute :gender, String
  attribute :birth_date, String
  attribute :ssn, String
  attribute :address, VaProfileAddress
  attribute :home_phone, String
  attribute :icn, String
  attribute :mhv_ids, String
  attribute :edipi, String
  attribute :vba_corp_id, String
end

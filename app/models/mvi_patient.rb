# frozen_string_literal: true
class MviPatientAddress
  include Virtus.model(strict: true, nullify_blank: true)

  attribute :street, String
  attribute :city, String
  attribute :state, String
  attribute :postal_code, String
  attribute :country, String
end

class MviPatient < Common::RedisStore
  include Virtus.model(strict: true, nullify_blank: true)

  attribute :active_status, String
  attribute :given_names, Array[String]
  attribute :family_name, String
  attribute :suffix, String
  attribute :gender, String
  attribute :birth_date, String
  attribute :ssn, String
  attribute :address, MviPatientAddress
  attribute :home_phone, String
  attribute :icn, String
  attribute :mhv_ids, String
  attribute :edipi, String
  attribute :vba_corp_id, String
end

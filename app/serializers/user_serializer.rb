# frozen_string_literal: true
require 'backend_services'

class UserSerializer < ActiveModel::Serializer
  attributes :services, :profile, :va_profile

  VA_PROFILE_STATUS = {
    ok: 'OK',
    not_found: 'NOT_FOUND',
    server_error: 'SERVER_ERROR'
  }.freeze

  def id
    nil
  end

  def profile
    {
      email: object.email,
      first_name: object.first_name,
      middle_name: object.middle_name,
      last_name: object.last_name,
      birth_date: object.birth_date,
      gender: object.gender,
      zip: object.zip,
      last_signed_in: object.last_signed_in,
      loa: object.loa
    }
  end

  def va_profile
    return { status: 'NOT_AUTHORIZED' } unless object.loa3?
    # raise MVI::Errors::RecordNotFound unless object.va_profile
    {
      status: VA_PROFILE_STATUS[:ok],
      birth_date: object.va_profile.birth_date,
      family_name: object.va_profile.family_name,
      gender: object.va_profile.gender,
      given_names: object.va_profile.given_names
    }
  rescue MVI::Errors::RecordNotFound
    { status: VA_PROFILE_STATUS[:not_found] }
  rescue MVI::Errors::ServiceError
    { status: VA_PROFILE_STATUS[:server_error] }
  end

  def services
    service_list = [
      BackendServices::FACILITIES,
      BackendServices::HCA,
      BackendServices::EDUCATION_BENEFITS
    ]
    service_list += BackendServices::MHV_BASED_SERVICES if object.can_access_mhv?
    service_list << BackendServices::EVSS_CLAIMS if object.can_access_evss?
    service_list << BackendServices::USER_PROFILE if object.can_access_user_profile?
    service_list
  rescue MVI::Errors::ServiceError, MVI::Errors::RecordNotFound
    service_list
  end
end

# frozen_string_literal: true

require 'common/models/collection'
require 'will_paginate/array'

class Vbeta::Facilities::VaController < FacilitiesController
  before_action :validate_params, only: [:index]

  # Index supports the following query parameters:
  # @param bbox - Bounding box in form "xmin,ymin,xmax,ymax" in Lat/Long coordinates
  # @param type - Optional facility type, values = all (default), health, benefits, cemetery
  # @param services - Optional specialty services filter
  def index
    # results = VAFacility.query(bbox: params[:bbox], type: params[:type], services: params[:services]) if params[:bbox]
    # resource = Common::Collection.new(::VAFacility, data: results)
    # resource = resource.paginate(pagination_params)
    bbox_num = params[:bbox].map { |x| Float(x) }
    results = Facilities::NCAFacility.where(lat: (bbox_num[1]..bbox_num[3]), long: (bbox_num[0]..bbox_num[2]))
    results += Facilities::VHAFacility.where(lat: (bbox_num[1]..bbox_num[3]), long: (bbox_num[0]..bbox_num[2]))
    results += Facilities::VBAFacility.where(lat: (bbox_num[1]..bbox_num[3]), long: (bbox_num[0]..bbox_num[2]))
    results += Facilities::VCFacility.where(lat: (bbox_num[1]..bbox_num[3]), long: (bbox_num[0]..bbox_num[2]))

    resource = Common::Collection.new(::VAFacility, data: results.sort_by(&(dist_from_center bbox_num))).paginate
    render json: resource.data,
           serializer: CollectionSerializer,
           each_serializer: VAFacilitySerializer,
           meta: resource.metadata
  end

  def show
    results = find_facility_by_type_and_id(params[:id])
    raise Common::Exceptions::RecordNotFound, params[:id] if results.nil?
    render json: results, serializer: VAFacilitySerializer
  end

  def all
    render json: BaseFacility.pluck(:unique_id, :facility_type).map { |pair| "#{mappings[pair.last]}_#{pair.first}" }.to_json
  end

  private

  def mappings
    { 'va_cemetery' => 'nca',
      'va_benefits_facility' => 'vba',
      'vet_center' => 'vc',
      'va_health_facility' => 'vha' }
  end

  def dist_from_center(bbox)
    lambda do |facility|
      center_x = (bbox[0] + bbox[2]) / 2.0
      center_y = (bbox[1] + bbox[3]) / 2.0
      Math.sqrt((facility.long - center_x)**2 + (facility.lat - center_y)**2)
    end
  end

  def find_facility_by_type_and_id(type_and_id)
    type, unique_id = type_and_id.split('_')
    return nil unless type && unique_id
    "Facilities::#{type.upcase}Facility".constantize.find(unique_id)
  end

  def validate_params
    super
    validate_no_services_without_type
    validate_type_and_services_known unless params[:type].nil?
  end

  def validate_no_services_without_type
    if params[:type].nil? && !params[:services].nil?
      raise Common::Exceptions::ParameterMissing.new('type', detail: TYPE_SERVICE_ERR)
    end
  end

  TYPE_SERVICE_ERR = 'Filtering by services is not allowed unless a facility type is specified'
  def validate_type_and_services_known
    raise Common::Exceptions::InvalidFieldValue.new('type', params[:type]) unless
      VAFacility::TYPES.include?(params[:type])
    unknown = params[:services].to_a - VAFacility.service_whitelist(params[:type])
    raise Common::Exceptions::InvalidFieldValue.new('services', unknown) unless unknown.empty?
  end
end

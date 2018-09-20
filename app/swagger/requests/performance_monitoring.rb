# frozen_string_literal: true

module Swagger
  module Requests
    class PerformanceMonitoring
      include Swagger::Blocks

      swagger_path '/v0/performance_monitorings' do
        operation :post do
          extend Swagger::Responses::AuthenticationError

          key :description, 'Call StatsD.measure with the passed page performance benchmarking data.'
          key :operationId, 'postPerformanceMonitoring'
          key :tags, %w[
            performance_monitoring
          ]

          parameter :authorization

          parameter do
            key :name, :body
            key :in, :body
            key :description, "Attributes to benckmark a page's performance in StatsD"
            key :required, true

            schema do
              key :required, %i[metric duration page_id]
              property :metric,
                       type: :string,
                       example: 'initial_page_load',
                       description: 'Creates a namespace/bucket for what is being measured.'
              property :duration,
                       type: :float,
                       example: 100.1,
                       description: 'Duration of benchmark measurement in milliseconds'
              property :page_id,
                       type: :string,
                       example: 'some_unique_page_indentifier',
                       description: 'A unique identifier for the frontend page being benchmarked'
            end
          end

          response 200 do
            key :description, 'Response is OK'
            schema do
              key :required, [:data]

              property :data, type: :object do
                key :required, [:attributes]
                property :id, type: :string
                property :type, type: :string, example: 'stats_d_instrument_metrics'
                property :attributes, type: :object do
                  key :required, %i[metric duration page_id]
                  property :metric, type: :string, example: 'frontend.page_performance.initial_page_load'
                  property :duration, type: :float, example: 100.1
                  property :page_id, type: :string, example: 'some_unique_page_indentifier'
                end
              end
            end
          end

          response 400 do
            key :description, 'Missing Parameter'
            schema do
              key :required, [:errors]

              property :errors do
                key :type, :array
                items do
                  key :required, %i[title detail code status source]
                  property :title, type: :string, example: 'Missing parameter'
                  property :detail,
                           type: :string,
                           example: 'A value is required for metric type :ms.'
                  property :code, type: :string, example: '108'
                  property :status, type: :string, example: '400'
                end
              end
            end
          end
        end
      end
    end
  end
end

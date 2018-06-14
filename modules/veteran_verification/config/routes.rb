# frozen_string_literal: true

VeteranVerification::Engine.routes.draw do
  match '/v0/*path', to: 'application#cors_preflight', via: [:options]

  namespace :docs do
    namespace :v0, defaults: { format: 'json' } do
      get 'service_history', to: 'api#history'
    end
  end
end

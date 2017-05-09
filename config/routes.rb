# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :api do
    namespace :v1 do
      resources :form_submissions
      resources :forms, shallow: true, except: %i[new create edit] do
        resources :sections, except: %i[new edit] do
          resources :questions, except: %i[new create edit] do
            resources :choices, except: %i[new create edit]
          end
        end
      end
    end
  end
end

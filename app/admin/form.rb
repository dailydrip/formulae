# frozen_string_literal: true

ActiveAdmin.register Form do
  permit_params :application_id, :completion_content
end

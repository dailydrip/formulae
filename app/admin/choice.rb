# frozen_string_literal: true

ActiveAdmin.register Choice do
  permit_params :label,
                :question_dependency_id,
                :question_id,
                :maximum_chosen
  form do |f|
    f.inputs 'Choices' do
      f.input :label
      f.input :maximum_chosen
      f.input :question_dependency
      f.input :question
      # more fields
    end
    f.actions
  end
end

# frozen_string_literal: true

module FormMethods
  def self.build_a_new_form
    build_form = FactoryGirl.build(:form)
    build_form.sections = FactoryGirl.build_list(:section, 3, form: build_form)
    build_form.sections.each do |section|
      section.questions << FactoryGirl.build(:question)
    end
    build_form
  end

  def self.create_params_for(form)
    desired_hash = {}
    desired_hash = form.slice(:id, :completion_content, :application_id)
    form.sections.map do |section|
      section_value = section.slice(:id, :form_id, :name, :order, :content, :_destroy)
      desired_hash[:sections] = []
      desired_hash[:sections] << section_value

      desired_hash[:sections].each do |sections_params|
        questions_for_section = section.questions.map do |q|
          q.slice(:id, :key, :label, :content, :order, :hidden,
                  :question_type, :validate_as, :section_id, :required,
                  :placeholder, :_destroy)
        end
        sections_params[:questions] = []
        sections_params[:questions] = questions_for_section
      end
    end
    desired_hash
  end
end

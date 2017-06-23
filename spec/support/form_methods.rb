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
end

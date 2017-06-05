# frozen_string_literal: true

class Api::V1::FormsController < Api::V1::ApiController
  before_action :find_form, only: %i[show destroy update]

  def index
    @forms = Form.all
    render json: @forms
  end

  def show
    render json: @form
  end

  def update
    if @form.update_attributes(form_params)
      render json: @form, status: :ok
    else
      render json: @form.errors, status: :unprocessable_entity
    end
  end

  def create
    ActiveRecord::Base.transaction do
      @form = Form.new(form_params)
      sections = params[:form][:sections]
      if @form.save!
        sections.each do |section_params|
          section = create_section_for(section_params, @form)
          create_question_for(section_params, section)
        end
        render json: @form, status: :created
      else
        render json: @form.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @form.destroy
      render json: :no_content, status: :no_content
    else
      render json: @form.errors, status: :unprocessable_entity
    end
  end

  private

  def find_form
    @form = Form.find(params[:id])
  end

  def form_params
    params.require(:form).permit(:application_id, :sections, :questions)
  end

  def create_section_for(section_params, form)
    Section.create!(
      name: section_params[:name],
      order: section_params[:order],
      content: section_params[:content],
      form: form
    )
  end

  def create_question_for(section_params, section)
    section_params[:questions].each do |q|
      Question.create!(
        key: q[:key],
        label: q[:label],
        content: q[:content],
        order: q[:order],
        placeholder: q[:placeholder],
        required: q[:required],
        question_type: q[:question_type],
        section: section
      )
    end
  end
end

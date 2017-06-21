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
      @form = Form.find(params[:form][:id])
      return edit_form if @form

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

  private def edit_form
    ActiveRecord::Base.transaction do
      begin
        sections = params[:form][:sections]
        sections.each do |section_params|
          edit_section_for(section_params)
          edit_question_for(section_params)
        end
        render json: @form, status: :no_content
      rescue
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
    params.require(:form).permit(:application_id, :completion_content, :sections, :questions)
  end

  def create_section_for(section_params, form)
    Section.create!(
      name: section_params[:name],
      order: section_params[:order],
      content: section_params[:content],
      form: form
    )
  end

  def edit_section_for(section_params)
    section_id = section_params[:id]
    section = Section.find_by(id: section_id)
    section = Section.create unless section

    section.update_attributes!(
      name: section_params[:name],
      order: section_params[:order],
      content: section_params[:content],
      form: @form
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
        validate_as: q[:validate_as],
        required: q[:required],
        question_type: q[:question_type],
        section: section
      )
    end
  end

  def edit_question_for(section_params)
    section_id = section_params[:id]
    section = Section.find(section_id)
    questions_params = section_params[:questions]

    old_questions = Question.where(section_id: section.id).map(&:id)
    added_questions = questions_params.map do |q_params|
      q = Question.find_by(id: q_params[:id])
      q = Question.create unless q
      q.update_attributes!(
        key: q_params[:key],
        label: q_params[:label],
        content: q_params[:content],
        order: q_params[:order],
        placeholder: q_params[:placeholder],
        validate_as: q_params[:validate_as],
        required: q_params[:required],
        question_type: q_params[:question_type],
        section: section
      )
      q.id
    end
    to_be_deleted = old_questions - added_questions
    Question.destroy(to_be_deleted)
  end
end

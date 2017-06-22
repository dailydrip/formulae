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

  def create
    ActiveRecord::Base.transaction do
      @form = Form.find(form_params[:id])
      if @form.update_attributes!(form_params)
        render json: @form, status: :created
      else
        render json: @form.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    ActiveRecord::Base.transaction do
      if @form.update_attributes!(form_params)
        render json: @form, status: :ok
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
    make_form_params
  end

  private def make_form_params
    # FIXME
    # ADD destroy field when we are worrying about destroying a section/question. We need to add it for both
    permitted = params.require(:form).permit(:id, :application_id, sections: [:id, :form_id, :name, :order, :content, questions: %i[id key label content order hidden question_type validate_as section_id required placeholder]])
    permitted[:sections_attributes] = permitted.delete(:sections)
    permitted[:sections_attributes].each do |section|
      section[:questions_attributes] = section.delete(:questions)
    end
    # But it does not update the ids generated by react
    # We dont need to have two types of IDS

    # Also, I NEED to worry in the case where I am updating one question and
    # destroying another question at the same time
    permitted
  end
end

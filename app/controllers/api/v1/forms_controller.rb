# frozen_string_literal: true

class Api::V1::FormsController < Api::V1::ApiController
  before_action :find_form, only: %i[show destroy]

  def index
    @forms = @application.forms.all
    render json: @forms
  end

  def show
    render json: @form
  end

  def create
    @form = @application.forms.find_or_initialize_by(id: form_params[:id])
    if !@form.persisted?
      @form = @application.forms.new(form_params)
      render_create
    else
      render_update
    end
  end

  private def render_create
    if @form.save
      render json: @form, status: :created
    else
      render json: @form.errors, status: :unprocessable_entity
    end
  end

  private def render_update
    if @form.update_attributes(form_params)
      render json: @form, status: :ok
    else
      render json: @form.errors, status: :unprocessable_entity
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
    # This make a standard for our form_params.
    # Here we are passing the correct parameter to work with nested_params and
    # we are permitting it to be used.
    permitted = params
                .require(:form)
                .permit(:id, :completion_content, :application_id,
                        sections: [:id, :form_id, :name, :order, :content, :_destroy,
                                   questions: [:id, :key, :label, :content, :order, :hidden,
                                               :question_type, :validate_as, :section_id, :required,
                                               :placeholder, :_destroy,
                                               choices: %i[
                                                 id metadata maximum_chosen label
                                               ]]])
    permitted[:sections_attributes] = permitted.delete(:sections)
    permitted[:sections_attributes].each do |section|
      section[:questions_attributes] = section.delete(:questions)
      section[:questions_attributes].each do |question|
        choices_attributes = question[:choices] ? question.delete(:choices) : []
        question[:choices_attributes] = choices_attributes
      end
    end
    permitted
  end
end

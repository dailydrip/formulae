# frozen_string_literal: true

class Api::V1::SectionsController < Api::V1::ApiController
  before_action :find_section, only: %i[show destroy update]

  def index
    @sections = Section.all
    render json: @sections
  end

  def create
    @section = Section.new(section_params)
    if @section.save!
      render json: @section, status: :created
    else
      render json: @section.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @section
  end

  def update
    if @section.update_attributes(section_params)
      render json: @section, status: :ok
    else
      render json: @section.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @section.destroy
      render json: :no_content, status: :no_content
    else
      render json: @section.errors, status: :unprocessable_entity
    end
  end

  private

  def find_section
    @section = Section.find(params[:id])
  end

  def section_params
    params.require(:section).permit(:form_id,
                                    :name,
                                    :order,
                                    :content)
  end
end

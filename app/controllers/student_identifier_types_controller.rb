# frozen_string_literal: true
class StudentIdentifierTypesController < ApplicationController
  include OrganizationAuthorization

  before_action :save_referer, only: [:new]

  def index
    not_found unless Classroom.flipper[:student_identifier].enabled? current_user
    @student_identifier_types = @organization.student_identifier_types
  end

  def new
    not_found unless Classroom.flipper[:student_identifier].enabled? current_user
    @student_identifier_type = StudentIdentifierType.new
  end

  def create
    not_found unless Classroom.flipper[:student_identifier].enabled? current_user
    @student_identifier_type = StudentIdentifierType.new(student_identifier_type_params)
    if @student_identifier_type.save
      flash[:success] = "\"#{student_identifier_type.name}\" has been created!"
      redirect_to session.delete(:return_to) || { action: 'index' }
    else
      render :new
    end
  end

  def student_identifier_type_params
    params
      .require(:student_identifier_type)
      .permit(:name, :description, :content_type)
      .merge(organization: @organization)
  end

  private

  def set_student_identifier_type
    @student_identifier_type = StudentIdentifierType.find_by(id: params[:id])
  end

  def save_referer
    session[:return_to] = request.referer
  end

  def student_identifier_type
    @student_identifier_type ||= StudentIdentifierType.find_by(id: params[:id])
  end
  helper_method :student_identifier_type
end

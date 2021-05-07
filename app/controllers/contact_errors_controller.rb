class ContactErrorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact_error, only: %i[show update destroy]

  # GET /contact_errors
  def index
    @contact_errors = ContactError.all

    render json: @contact_errors
  end

  # GET /contact_errors/1
  def show
    render json: @contact_error
  end

  # POST /contact_errors
  def create
    @contact_error = ContactError.new(contact_error_params)

    if @contact_error.save
      render json: @contact_error, status: :created, location: @contact_error
    else
      render json: @contact_error.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contact_errors/1
  def update
    if @contact_error.update(contact_error_params)
      render json: @contact_error
    else
      render json: @contact_error.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contact_errors/1
  def destroy
    @contact_error.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contact_error
    @contact_error = ContactError.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def contact_error_params
    params.require(:contact_error).permit(:line, :line_number, :errors, :attempt, :user_id, :contact_file_id)
  end
end

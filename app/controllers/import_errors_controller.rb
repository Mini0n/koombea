class ImportErrorsController < ApplicationController
  before_action :set_import_error, only: [:show, :update, :destroy]

  # GET /import_errors
  def index
    @import_errors = ImportError.all

    render json: @import_errors
  end

  # GET /import_errors/1
  def show
    render json: @import_error
  end

  # POST /import_errors
  def create
    @import_error = ImportError.new(import_error_params)

    if @import_error.save
      render json: @import_error, status: :created, location: @import_error
    else
      render json: @import_error.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /import_errors/1
  def update
    if @import_error.update(import_error_params)
      render json: @import_error
    else
      render json: @import_error.errors, status: :unprocessable_entity
    end
  end

  # DELETE /import_errors/1
  def destroy
    @import_error.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_import_error
      @import_error = ImportError.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def import_error_params
      params.require(:import_error).permit(:line, :line_number, :errors, :attempt, :user_id, :contact_file_id)
    end
end

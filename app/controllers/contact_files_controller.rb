class ContactFilesController < ApplicationController
  before_action :set_contact_file, only: [:show, :update, :destroy]

  # GET /contact_files
  def index
    @contact_files = ContactFile.all

    render json: @contact_files
  end

  # GET /contact_files/1
  def show
    render json: @contact_file
  end

  # POST /contact_files
  def create
    @contact_file = ContactFile.new(contact_file_params)

    if @contact_file.save
      render json: @contact_file, status: :created, location: @contact_file
    else
      render json: @contact_file.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contact_files/1
  def update
    if @contact_file.update(contact_file_params)
      render json: @contact_file
    else
      render json: @contact_file.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contact_files/1
  def destroy
    @contact_file.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact_file
      @contact_file = ContactFile.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def contact_file_params
      params.require(:contact_file).permit(:name, :status, :lines, :columns, :user_id)
    end
end

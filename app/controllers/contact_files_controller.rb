class ContactFilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact_file, only: %i[show update destroy]

  # GET /contact_files or /contact_files.json
  def index
    @contact_files = ContactFile.all
  end

  # GET /contact_files/1 or /contact_files/1.json
  def show; end

  # GET /contact_files/new
  def new
    @contact_file = ContactFile.new
  end

  # GET /contact_files/1/edit
  def edit; end

  # POST /contact_files or /contact_files.json
  def create
    @contact_file = ContactFile.new(contact_file_params)
    @contact_file.update(
      name: @contact_file.name = contact_file_params[:csv_file].original_filename,
      lines: 1,
      status: 'On Hold',
      user: current_user
    )

    respond_to do |format|
      if @contact_file.save
        format.html { redirect_to @contact_file, notice: 'Contact file was successfully created.' }
        format.json { render :show, status: :created, location: @contact_file }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contact_files/1 or /contact_files/1.json
  def update
    respond_to do |format|
      if @contact_file.update(contact_file_params)
        format.html { redirect_to @contact_file, notice: 'Contact file was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact_file }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contact_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_files/1 or /contact_files/1.json
  def destroy
    @contact_file.destroy
    respond_to do |format|
      format.html { redirect_to contact_files_url, notice: 'Contact file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contact_file
    @contact_file = ContactFile.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contact_file_params
    # params.require(:contact_file).permit(:name, :status, :lines, :columns, :user_id,
    #                                      :header_image) # Uploaded file

    params.require(:contact_file).permit(:columns,
                                         :csv_file) # Uploaded file
  end
end

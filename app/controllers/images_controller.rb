require 'water_mark_worker.rb'
class ImagesController < ApplicationController
  include WaterMarkWorker
  
  before_action :set_image, only: [:show, :edit, :update, :destroy, :download]

  # GET /projects/1/images
  # GET /projects/1/images.json
  def index
    @images = scoper.all
  end

  # GET /images/1
  # GET /images/1.json
  def show    
  end

  # GET /projects/1/images/new
  def new
    @image = scoper.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /projects/1/images
  # POST /projects/1/images.json
  def create
    @image = scoper.new(image_params)

    respond_to do |format|
      if @image.save
        format.html { redirect_to image_path(@image), notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to image_path(@image), notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to project_images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download
    watermarked_image_location = perform_watermark(@image)
    
    File.open(watermarked_image_location, 'r') do |f|
      send_data f.read, type: 'image/jpeg'
    end
    File.delete(watermarked_image_location)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def scoper
      @project = current_user.projects.find(params[:project_id])
      @project.images
    end

    def set_image
      @image = Image.find(params[:id])
      @project = @image.project
      
      unless current_user == @project.user
        flash[:notice] = "This image doesn't belong to you"
        redirect_to root_url
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:name, :description, :original)
    end

    def live_paper
      LivePaperWrapper.new
    end
end

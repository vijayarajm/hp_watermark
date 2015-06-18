class RegionsController < ApplicationController
  before_action :set_region, only: [:show, :edit, :update, :destroy]
  before_action :scoper, :set_payoff, only: [:create]

  # GET /regions
  # GET /regions.json
  def index
    @regions = scoper.all
  end

  # GET /regions/1
  # GET /regions/1.json
  def show
  end

  # GET /regions/new
  def new
    @region = scoper.new
  end

  # GET /regions/1/edit
  def edit
  end

  # POST /regions
  # POST /regions.json
  def create
    @region = scoper.new(region_params)

    respond_to do |format|
      if @region.save
        format.html { redirect_to region_path(@region), notice: 'Region was successfully created.' }
        format.json { render :show, status: :created, location: @region }
      else
        format.html { render :new }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /regions/1
  # PATCH/PUT /regions/1.json
  def update
    respond_to do |format|
      if @region.update(region_params)
        format.html { redirect_to region_path(@region), notice: 'Region was successfully updated.' }
        format.json { render :show, status: :ok, location: @region }
      else
        format.html { render :edit }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /regions/1
  # DELETE /regions/1.json
  def destroy
    @region.destroy
    respond_to do |format|
      format.html { redirect_to image_regions_url(@image), notice: 'Region was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def scoper
      @image = Image.find(params[:image_id])
      @image.regions if @image
    end

    def set_region
      @region = Region.find(params[:id])
      @image = @region.image
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def region_params
      params.require(:region).permit(:name, :top_left_x, :top_left_y, :width, :height, 
        :watermark_resolution, :watermark_strength, :payoff_id)
    end

    def set_payoff
      if params[:payoff][:id].present?
        params[:region][:payoff_id] = params[:payoff][:id]
      else
        payoff = @image.project.payoffs.create(:name => params[:payoff][:name], :url => params[:payoff][:url])
        params[:region][:payoff_id] = payoff.id
      end
    end
end

class PayoffsController < ApplicationController
  before_action :set_payoff, only: [:show, :edit, :update, :destroy]

  # GET /payoffs
  # GET /payoffs.json
  def index
    @payoffs = scoper.all
  end

  # GET /payoffs/1
  # GET /payoffs/1.json
  def show
  end

  # GET /payoffs/new
  def new
    @payoff = scoper.new
  end

  # GET /payoffs/1/edit
  def edit
  end

  # POST /payoffs
  # POST /payoffs.json
  def create
    @payoff = scoper.new(payoff_params)

    respond_to do |format|
      if @payoff.save
        format.html { redirect_to payoff_path(@payoff), notice: 'Payoff was successfully created.' }
        format.json { render :show, status: :created, location: @payoff }
      else
        format.html { render :new }
        format.json { render json: @payoff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payoffs/1
  # PATCH/PUT /payoffs/1.json
  def update
    respond_to do |format|
      if @payoff.update(payoff_params)
        format.html { redirect_to payoff_path(@payoff), notice: 'Payoff was successfully updated.' }
        format.json { render :show, status: :ok, location: @payoff }
      else
        format.html { render :edit }
        format.json { render json: @payoff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payoffs/1
  # DELETE /payoffs/1.json
  def destroy
    @payoff.destroy
    respond_to do |format|
      format.html { redirect_to payoff_path(@payoff), notice: 'Payoff was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def scoper
      @project = current_user.projects.find(params[:project_id])
      @project.payoffs if @project
    end

    def set_payoff
      @payoff = Payoff.find(params[:id])
      @project = @payoff.project
      
      unless current_user == @payoff.project.user
        flash[:notice] = "This payoff doesn't belong to you"
        redirect_to root_url
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payoff_params
      params.require(:payoff).permit(:name, :url)
    end
end

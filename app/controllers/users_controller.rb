class UsersController < ApplicationController
  skip_before_action :deny_access, :only => [:activate]

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :admin?, except: [:activate]
  before_action :load_with_perishable_token, only: [:activate]

  # GET users
  # GET users.json
  def index
    @users = User.all
  end

  # GET users/1
  # GET users/1.json
  def show
  end

  # GET users/new
  def new
    @user = User.new
  end

  # GET users/1/edit
  def edit
  end

  # POST users
  # POST users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT users/1
  # PATCH/PUT users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE users/1
  # DELETE users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def activate
    if request.post?
      if !params[:password].nil? and (params[:password] == params[:password_confirmation])
        @user.password = params[:password]
        
        if @user.save
          @user.reset_perishable_token!
          redirect_to projects_path
          flash.now[:success] = "Activated successfully."
        end
      else
        flash.now[:error] = "There was a problem activating your account."
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def admin?
      unless current_user.admin?  
        flash[:notice] = "You are not authorized to view this page."
        redirect_to root_path
      end 
    end

    def set_user
      @user = User.find(params[:id])
    end

    def load_with_perishable_token
      if current_user_session.nil? 
        @user = User.find_by_perishable_token(params[:token]) 
      else
        redirect_to root_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user].permit(:username, :email, :client_id, :client_secret)
    end

end
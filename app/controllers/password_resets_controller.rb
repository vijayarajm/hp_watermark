class PasswordResetsController < ApplicationController

  skip_before_action :deny_access
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [ :edit, :update ]

  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions
      flash[:notice] = "Instructions to reset your password have been emailed to you"
      redirect_to login_path
    else
      flash.now[:error] = "No user was found with email address - #{params[:email]}"
      render :action => :new
    end
  end

  def edit
  end

  def update
    @user.password = params[:password]

    if (params[:password] == params[:password_confirmation]) and @user.save
      flash[:success] = "Your password was successfully updated"
      redirect_to root_path
    else
      flash[:error] = "Passwords don't match. Please try again."
      render :action => :edit
    end
  end

  private
    def load_user_using_perishable_token
      @user = User.find_using_perishable_token(params[:id])
      unless @user
        flash[:error] = "We're sorry, but we could not locate your account"
        redirect_to root_url
      end
    end

end
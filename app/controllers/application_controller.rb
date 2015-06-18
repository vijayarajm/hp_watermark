class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # filter_parameter_logging :password
  skip_before_action :verify_authenticity_token
  
  helper_method :current_user_session, :current_user
  before_filter :deny_access, :unset_current_user, :set_current_user

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  def deny_access
    unless authorized?
      flash[:error] = "You are not allowed to access this page."
      redirect_to login_path 
    end
  end

  def authorized?
    current_user
  end

  def admin?
    current_user.admin
  end

  def require_no_user
    if current_user
      store_location
      redirect_to root_path
      return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def unset_current_user
    Thread.current[:user] = nil
  end

  def set_current_user
    current_user.set_current if current_user
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
end

class HomeController < ApplicationController
  skip_before_action :deny_access
  
  def index
  end
end
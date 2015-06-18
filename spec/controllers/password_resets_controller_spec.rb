require 'rails_helper'
require 'spec_helper'

describe PasswordResetsController do
  setup :activate_authlogic

  it "should render a new PasswordReset form" do
    get :new
    response.status.should eql 200
  end

  it "should create new password" do
    post :create, :email => User.first.email
    response.status.should eql 302
  end

  it "should update new password" do
    put :update, :id => User.first.perishable_token, :password => "test", :password_confirmation => "test"
    response.status.should eql 302
  end
end

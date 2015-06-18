require 'rails_helper'
require 'spec_helper'

describe UsersController do
  setup :activate_authlogic

  before(:each) do
    @user = User.first
    activate_authlogic
    UserSession.create(@user)
  end

  it 'should add a new user' do
    post 'create', { :user => { :username => "test", :email => "test@test.com", 
      :client_id => "test", :client_secret => "test" }}

    user = User.find_by_email("test@test.com")
    user.should_not be_nil
  end

  it "should not add user when username or email already exists" do
    post 'create', :user => { :username => "test", :email => "test@test.com", 
      :client_id => "test", :client_secret => "test" }
    
    response.body.should =~ /redirected/
  end

  it "should activate user" do
    post :activate, :token => User.last.perishable_token, :password => "test1", 
      :password_confirmation => "test2"

    User.last.crypted_password.should_not be_nil
  end 

  it "should update user" do
    put :update, :id => User.last.id, :user => { :email => "test1@test.com" }

    User.last.email.should eql "test1@test.com"
  end 

  it "should list users" do
    get :index
    
    response.status.should eql 200
  end 

  it "should show user" do
    get :show, :id => User.last.id
    
    response.status.should eql 200
  end 
end

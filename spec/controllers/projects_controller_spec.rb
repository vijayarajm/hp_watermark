require 'rails_helper'
require 'spec_helper'

describe ProjectsController do
  setup :activate_authlogic

  before(:each) do
    @user = User.first
    activate_authlogic
    UserSession.create(@user)
    @user.set_current
  end

  it 'should add a new project' do
    post 'create', { :project => { :name => "test", :description => "Test description" }}

    project = Project.find_by_name("test")
    project.should_not be_nil
  end

  it "should not add project when name is not given" do
    expect {
        post 'create', { :project => {} }
      }.to raise_error(ActionController::ParameterMissing)
  end

  it "should update project" do
    @user.projects.create({ :name => "Test", :description => "Test description" })
    put :update, { :id => Project.last.id, :project => { :name => "new_name" }}

    Project.last.name.should eql "new_name"
  end 

  it "should list projects" do
    @user.projects.create({ :name => "Test", :description => "Test description" })
    get :index
    
    response.status.should eql 200
  end 

  it "should show projects" do
    @user.projects.create({ :name => "Test", :description => "Test description" })
    get :show, :id => Project.last.id
    
    response.status.should eql 200
  end 
end

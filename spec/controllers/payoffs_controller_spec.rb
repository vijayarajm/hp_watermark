require 'rails_helper'
require 'spec_helper'

describe PayoffsController do
  setup :activate_authlogic

  before(:each) do
    @user = User.first
    activate_authlogic
    UserSession.create(@user)
    @user.set_current

    @project = @user.projects.create({ :name => "Test", :description => "Test description" })
  end

  it 'should add a new payoff' do
    post 'create', { :payoff => { :name => "Test", :url => "http://www.test.com"}, 
      :project_id => @project.id }

    payoff = Payoff.find_by_name("Test")
    payoff.should_not be_nil
    payoff.remote_payoff_id.should_not be_nil
  end

  it "should not add payoff when name is not given" do
    expect{
      post 'create', { :payoff => {}, :project_id => @project.id }
    }.to raise_error(ActionController::ParameterMissing)
  end

  it "should update payoff" do
    @project.payoffs.create(:name => "Test", :url => "http://www.test.com")
    put :update, { :id => Payoff.last.id, :payoff => { :name => "http://www.newtest.com" }, :project_id => @project.id }

    Payoff.last.name.should eql "http://www.newtest.com"
  end 

  it "should list payoffs" do
    @project.payoffs.create(:name => "Test", :url => "http://www.test.com")
    get :index, :project_id => @project.id
    
    response.status.should eql 200
  end 

  it "should show payoff" do
    @project.payoffs.create(:name => "Test", :url => "http://www.test.com")
    get :show, :id => Payoff.last.id
    
    response.status.should eql 200
  end 
end

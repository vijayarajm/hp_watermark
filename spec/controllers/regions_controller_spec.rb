require 'rails_helper'
require 'spec_helper'

describe RegionsController do
  setup :activate_authlogic

  before(:each) do
    @user = User.first
    activate_authlogic
    UserSession.create(@user)
    @user.set_current

    @project = @user.projects.create({ :name => "Test Project", :description => "Test description" })
    @file = fixture_file_upload("files/photo.jpg", 'image/jpg')
    @image = @project.images.create({ :name => "Test Image", :original => @file })
    @payoff = @project.payoffs.create({ :name => "Test Payoff", :url => "http://www.test.com" })
    @region_params = { :name => "Test", :top_left_x => 1, :top_left_y => 100, :width => 100, 
      :height => 100, :watermark_strength => 80, :watermark_resolution => 50 }
  end

  it 'should add a new region with existing payoff' do
    post 'create', { :region => @region_params, :payoff => { :id => @payoff.id },
     :image_id => @image.id }

    region = Region.last
    region.should_not be_nil
    region.remote_trigger_id.should_not be_nil # Checks if the remote trigger is created in Link Studio 
    region.remote_link_id.should_not be_nil # Checks if the remote link is created in Link Studio
  end

  it 'should add a new region with new payoff' do
    post 'create', { :region => @region_params, :payoff => { :name => "New Payoff", :url => "http://www.test.com" },
     :image_id => @image.id }

    region = Region.last
    region.should_not be_nil
    region.remote_trigger_id.should_not be_nil # Checks if the remote trigger is created in Link Studio 
    region.remote_link_id.should_not be_nil # Checks if the remote link is created in Link Studio
    region.remote_link_url.should_not be_nil
    region.remote_trigger_url.should_not be_nil
  end

  it "should not add region when payoff or region params are not given" do
    expect {
      post 'create', { :region => {}, :image_id => @image.id }
    }.to raise_error(ActionController::ParameterMissing)
  end

  it "should update region" do
    @image.regions.create(@region_params.merge(:payoff_id => @payoff.id))
    put :update, { :id => Region.last.id, :region => { :watermark_resolution => 90 }, 
      :image_id => @image.id }

    Region.last.watermark_resolution.should eql 90
  end 

  it "should list regions" do
    @image.regions.create(@region_params.merge(:payoff_id => @payoff.id))
    get :index, :image_id => @image.id

    response.status.should eql 200
  end 

  it "should show a region" do
    @image.regions.create(@region_params.merge(:payoff_id => @payoff.id))
    get :show, :id => Region.last.id
    
    response.status.should eql 200
  end 
end

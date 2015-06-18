require 'rails_helper'
require 'spec_helper'

describe ImagesController do
  setup :activate_authlogic

  before(:each) do
    @user = User.first
    activate_authlogic
    UserSession.create(@user)
    @user.set_current

    @project = @user.projects.create({ :name => "Test", :description => "Test description" })
    @file = fixture_file_upload("files/photo.jpg", 'image/jpg')
  end

  # it 'should add a new image' do
  #   post 'create', { :image => { :name => "Test", :description => "Test description", 
  #     :original => @file }, :project_id => @project.id }

  #   image = Image.last
    
  #   image.should_not be_nil
  #   image.width.should_not be_nil
  #   image.height.should_not be_nil
  #   image.original_url.should_not be_nil # Checks if the image is uploaded to Link storage
  # end

  # it "should not add image when image is not given" do
  #   expect {
  #     post 'create', { :image => {}, :project_id => @project.id }
  #   }.to raise_error(ActionController::ParameterMissing)
  # end

  # it "should generate watermarked image and download" do
  #   @image = @project.images.create({ :name => "Test", :description => "Test description", :original => @file })
  #   @payoff = @project.payoffs.create({ :name => "Test Payoff", :url => "http://www.test.com" })
  #   @image.regions.create(:name => "Test", :top_left_x => 1, :top_left_y => 100, :width => 100, 
  #     :height => 100, :watermark_strength => 80, :watermark_resolution => 50, :payoff_id => @payoff.id)

  #   get 'download', :id => @image.id

  #   Image.last.final_url.should_not be_nil
  # end

  # it "should update image" do
  #   @project.images.create({ :name => "Test", :description => "Test description", :original => @file })
  #   put :update, { :id => Image.last.id, :image => { :name => "new_name" }, :project_id => @project.id }

  #   Image.last.name.should eql "new_name"
  # end 

  # it "should list images" do
  #   @project.images.create({ :name => "Test", :description => "Test description", :original => @file  })
  #   get :index, :project_id => @project.id
    
  #   response.status.should eql 200
  # end 

  # it "should show image" do
  #   @project.images.create({ :name => "Test", :description => "Test description", :original => @file  })    
  #   get :show, :id => Image.last.id
    
  #   response.status.should eql 200
  # end 

  it "should destroy image" do
    image = @project.images.create({ :name => "Test", :description => "Test description", :original => @file  })    
    image_id = image.id
    delete :destroy, :id => image_id
    
    Image.find_by_id(image_id).should be_nil
  end 
end

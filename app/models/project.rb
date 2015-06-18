class Project < ActiveRecord::Base

  has_many :images
  has_many :payoffs

  belongs_to :user

  validates_presence_of :name

  has_attached_file :logo
  validates_attachment :logo,
    :content_type => { :content_type => ["image/jpeg", "image/png"] }
end

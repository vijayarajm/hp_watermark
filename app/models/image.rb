class Image < ActiveRecord::Base

  has_many :regions, :dependent => :destroy
  belongs_to :project

  validates_presence_of :name, :original
  
  has_attached_file :original
  validates_attachment :original,
    :content_type => { :content_type => ["image/jpeg", "image/jpg"] }

  after_save :upload_image, :set_dimensions

  def local_url
    %(public#{original.url.split('?').first})
  end

  private
    def upload_image      
      self.update_column(:original_url, live_paper.upload_image(local_url))
    end

    def set_dimensions
      image = Magick::Image.ping(local_url).first
      self.update_column(:width, image.columns)
      self.update_column(:height, image.rows)
    end

    def live_paper
      LivePaperWrapper.new
    end
end

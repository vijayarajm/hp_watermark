class Region < ActiveRecord::Base
  include WaterMarkWorker

  belongs_to :image
  belongs_to :payoff

  after_create :create_remote_resources
  after_update :update_remote_resources
  after_destroy :delete_remote_resources

  validates_presence_of :name, :top_left_x, :top_left_y, :width, :height, :watermark_strength, 
    :watermark_resolution

  def remote_trigger_url
    %(https://www.livepaperapi.com/api/v1/triggers/#{remote_trigger_id})
  end

  def remote_link_url
    %(https://www.livepaperapi.com/api/v1/links/#{remote_link_id})
  end

  # converting percentage to a valid rmagick value
  def watermark_strength_value
    (watermark_strength/10.0).to_f
  end

  # converting percentage to a valid rmagick value
  def watermark_resolution_value
    (watermark_resolution/10.0).to_f
  end

  private
    def create_remote_resources
      extracted_image = extract_image_region(image.local_url, self)
      remote_image = live_paper.upload_image(extract_image_region(image.local_url, self))
      remote_trigger = live_paper.create_trigger(name, watermark_strength_value, 
        watermark_resolution_value, remote_image)
      remote_payoff = live_paper.get_payoff(payoff.remote_payoff_id)
      remote_link = live_paper.create_link("link_#{id}", remote_trigger, remote_payoff)
      File.delete(extract_image_region(image.local_url, self))
      
      self.update_column(:remote_trigger_id, remote_trigger.id)
      self.update_column(:remote_link_id, remote_link.id)
    end

    def update_remote_resources      
      remote_trigger = live_paper.update_trigger(remote_trigger_id, name, watermark_strength_value, 
        watermark_resolution_value, image.original_url)
      remote_trigger = live_paper.get_trigger(remote_trigger_id)
      remote_payoff = live_paper.get_payoff(payoff.remote_payoff_id)
      live_paper.update_link(remote_link_id, remote_trigger, remote_payoff)
    end

    def delete_remote_resources
      live_paper.delete_link(remote_link_id)
      live_paper.delete_trigger(remote_trigger_id)
    end

    def live_paper
      LivePaperWrapper.new
    end
end

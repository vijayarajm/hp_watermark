require "RMagick"

module WaterMarkWorker

  def perform_watermark(image_model)
    image = Magick::Image.read(image_model.local_url).first

    image_model.regions.each do |region|
      watermark = image.crop(region.top_left_x, region.top_left_y, region.width, region.height)
      watermark.background_color = "Transparent"
      watermarked_version = watermark.modulate(region.watermark_strength_value, 
        region.watermark_resolution_value)
      image = image.composite(watermarked_version, region.top_left_x, region.top_left_y, 
        Magick::SoftLightCompositeOp)
    end
    
    final_image_location = %(#{Rails.root}/public/watermarked_final_#{Time.now.to_i}.jpg)
    image.write(final_image_location)
    image_model.update_attributes(:final_url => LivePaperWrapper.new.upload_image(final_image_location))
    final_image_location
  end 

  def extract_image_region(image_location, region)
    image = Magick::Image.read(image_location).first
    image_location = image.crop(region.top_left_x, region.top_left_y, region.width, region.height)
    
    final_image_location = %(#{Rails.root}/public/extracted_image_#{Time.now.to_i}.jpg)
    image.write(final_image_location)
    region.update_column(:original_url, LivePaperWrapper.new.upload_image(final_image_location))
    final_image_location
  end

  def live_paper
    LivePaperWrapper.new
  end
end
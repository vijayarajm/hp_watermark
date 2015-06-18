class AddAttachmentOriginalToImages < ActiveRecord::Migration
  def self.up
    change_table :images do |t|
      t.attachment :original
    end
  end

  def self.down
    remove_attachment :images, :original
  end
end

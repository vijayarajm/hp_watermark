class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.integer :image_id, :null => false
      t.integer :payoff_id, :null => false
      t.string :name
      t.integer :top_left_x
      t.integer :top_left_y
      t.integer :height
      t.integer :width
      t.string :original_url
      t.string :watermark_url
      t.integer :watermark_strength
      t.integer :watermark_resolution
      t.string :remote_link_id
      t.string :remote_trigger_id

      t.foreign_key :images
      t.foreign_key :payoffs

      t.timestamps
    end
  end
end

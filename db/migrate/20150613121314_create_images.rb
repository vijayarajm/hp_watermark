class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :project_id, :null => false
      t.string :name
      t.string :description
      t.string :original_url
      t.string :final_url
      t.string :logo
      t.integer :height
      t.integer :width

      t.foreign_key :projects
      t.timestamps
    end
  end
end

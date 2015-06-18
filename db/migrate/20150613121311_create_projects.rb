class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|      
      t.integer :user_id, :null => false
      t.string :name
      t.string :description

      t.foreign_key :users
      t.timestamps
    end
  end
end

class CreatePayoffs < ActiveRecord::Migration
  def change
    create_table :payoffs do |t|
      t.integer :project_id, :null => false
      t.string :name
      t.string :destination
      t.string :payoff_url

      t.foreign_key :projects
      t.timestamps
    end
  end
end

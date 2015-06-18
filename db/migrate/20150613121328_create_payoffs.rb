class CreatePayoffs < ActiveRecord::Migration
  def change
    create_table :payoffs do |t|
      t.integer :project_id, :null => false
      t.string :name
      t.string :url
      t.string :remote_payoff_id

      t.foreign_key :projects
      t.timestamps
    end
  end
end

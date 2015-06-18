class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :client_id
      t.string :client_secret
      t.boolean :admin

      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :perishable_token

      t.timestamps
    end
  end
end

class PopulateDefaultUsers < ActiveRecord::Migration
  def change
    User.create(:username => "admin", :email => "admin@admin.com", :admin => true, 
      :client_id => "p6a0red5io6r6zxlr7pufqrjntqacch3", :client_secret => "H3i0MW2pkWuR9iQQpYfnci3OIupj3v8j",
      :password => "admin", :password_confirmation => "admin")

    User.create(:username => "nonadmin", :email => "nonadmin@nonadmin.com", :admin => false, 
      :client_id => "p6a0red5io6r6zxlr7pufqrjntqacch3", :client_secret => "H3i0MW2pkWuR9iQQpYfnci3OIupj3v8j",
      :password => "nonadmin", :password_confirmation => "nonadmin")
  end
end

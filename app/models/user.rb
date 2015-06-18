class User < ActiveRecord::Base
  
  has_many :projects
  acts_as_authentic do |c|
    c.validates_length_of_password_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials? }    
  end

  # after_create :invite_user

  def self.current
    Thread.current[:user]
  end

  def self.reset_current_account
    Thread.current[:user] = nil
  end

  def set_current
    Thread.current[:user] = self
  end

  def deliver_password_reset_instructions
    reset_perishable_token!
    UserMailer.password_reset_instructions(self).deliver
  end

  private
    def has_no_credentials?
      self.crypted_password.blank?
    end

    def invite_user
      UserMailer.invite_user(self).deliver
    end
end

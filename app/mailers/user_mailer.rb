class UserMailer < ActionMailer::Base
  default from: "vraj.mdu@gmail.com"

  def invite_user(user)
    @user = user
    @url  = activate_url(@user.perishable_token)
    mail :to => user.email, :subject => "Activate your Watermark account."
  end

  def password_reset_instructions(user)
    @user = user
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)    
    mail :to => user.email, :subject => "Watermark account - Password Reset Instructions"
  end
end

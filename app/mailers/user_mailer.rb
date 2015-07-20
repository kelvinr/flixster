class UserMailer < ActionMailer::Base
  def welcome_email(user_id)
    @user = User.find(user_id)
    mail to: @user.email, from: "info@flixster", subject: "Welcome to Flixster!"
  end

  def password_reset(user_id)
    @user = User.find(user_id)
    @user.create_reset_digest
    mail to: @user.email, from: "security@flixster", subject: "Password reset requested."
  end

  def send_invitation_email(invitation_id)
    @invitation = Invitation.find(invitation_id)
    mail to: @invitation.recipient_email, from: "info@flixster.com", subject: "Invitation to join Flixster"
  end
end

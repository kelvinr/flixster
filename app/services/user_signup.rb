class UserSignup
  attr_reader :error_msg

  def initialize(user)
    @user = user
  end
 
  def sign_up(stripe_token, invitation_token=nil)
    if @user.valid?
      customer = StripeWrapper::Customer.create(
        :user => @user,
        :card => stripe_token
      )
      if customer.successful?
        @user.customer_token = customer.customer_token
        @user.save
        handle_invitation(invitation_token)
        @user.ship('welcome_email')
        @status = :success
        self
      else
        @status = :failed
        @error_msg = customer.error_message
        self
      end
    else
      @status = :failed
      @error_msg = "Invalid user info."
      self
    end
  end

  def successful?
    @status == :success
  end

private

  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.find_by(token: invitation_token)
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update(token: nil)
    end
  end
end

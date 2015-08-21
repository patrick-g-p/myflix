class UserRegistration
  def initialize(user)
    @user = user
  end

  def register_new_user(stripeToken, invitation_token=nil)
    if @user.valid?
      charge = StripeWrapper::Charge.create(amount: 999, token: stripeToken, user_email: @user.email)

      if charge.successful?
        @user.save

        if invitation_token
          invitation = Invitation.find_by(invitation_token: invitation_token)
          handle_invitation(@user, invitation)
        end

        UserMailer.delay.registration_welcome_email(@user.id)
        @status = :successful
        self
      else
        @error_message = charge.error_message
        @status = :failed
        self
      end
    else
      @status = :failed
      self
    end
  end

  def successful?
    @status == :successful
  end

  def error_message
    @error_message ? @error_message : 'Please fix any errors below. Your card was not charged.'
  end

  private

  def handle_invitation(new_user, invitation)
    new_user.follow(invitation.inviter)
    invitation.inviter.follow(new_user)
    invitation.clear_token!
  end
end

class UserRegistration
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def register_new_user(stripe_token, invitation_token=nil)
    if @user.valid?
      charge = StripeWrapper::Charge.create(amount: 999, token: stripe_token, user_email: @user.email)

      if charge.successful?
        @user.save

        if invitation_token
          handle_invitation(@user, invitation_token)
        end

        UserMailer.delay.registration_welcome_email(@user.id)
        @status = :successful
        self
      else
        @status = :failed
        @error_message = charge.error_message
        self
      end
    else
      @status = :failed
      @error_message = 'Please fix any errors below. Your card was not charged.'
      self
    end
  end

  def successful?
    @status == :successful
  end

  private

  def handle_invitation(new_user, invitation_token)
    invitation = Invitation.find_by(invitation_token: invitation_token)
    
    new_user.follow(invitation.inviter)
    invitation.inviter.follow(new_user)
    invitation.clear_token!
  end
end

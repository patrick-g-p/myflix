class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    invitation = Invitation.find_by(invitation_token: params[:token])

    if @user.save
      stripe_payment(params[:stripeToken], @user.email)

      session[:user_id] = @user.id
      UserMailer.delay.registration_welcome_email(current_user.id)

      if invitation
        handle_invitation(invitation)
      end

      flash[:success] = 'Your account was set up. Welcome to MyFlix!'
      redirect_to home_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def register_with_token
    invitation = Invitation.find_by(invitation_token: params[:token])

    if invitation
      @user = User.new(email: invitation.recipients_email)
      @token = invitation.invitation_token
      render :new
    else
      flash[:warning] = 'That invitation is no longer valid.'
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def handle_invitation(invitation)
    current_user.follow(invitation.inviter)
    invitation.inviter.follow(current_user)
    invitation.clear_token!
  end

  def stripe_payment(passed_in_token, users_email)
    Stripe.api_key = ENV.fetch('STRIPE_TEST_SK')

    begin
      charge = Stripe::Charge.create(
        :amount => 999,
        :currency => "usd",
        :source => passed_in_token,
        :description => "Registration charge for #{users_email}"
      )
    rescue Stripe::CardError => e
      flash[:danger] = e.message
    end
  end
end

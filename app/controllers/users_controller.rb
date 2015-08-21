class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    registration = UserRegistration.new(@user).register_new_user(params[:stripeToken], params[:token])

    if registration.successful?
      session[:user_id] = @user.id
      flash[:success] = 'Your account was set up. Welcome to MyFlix!'
      redirect_to home_path
    else
      flash.now[:danger] = registration.error_message
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
end

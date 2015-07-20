class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.inviter = current_user

    if @invitation.save
      @invitation.send_invitation
      flash[:success] = 'Your invite has been sent!'
      redirect_to invite_path
    else
      flash[:danger] = 'Some of the fields below contain errors.'
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipients_email, :recipients_name, :message)
  end
end

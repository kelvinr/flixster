class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))

    if @invitation.save
      UserMailer.delay.send_invitation_email(@invitation.id)
      flash[:success] = "You have successfully invited #{@invitation.recipient_name}."
      redirect_to new_invitation_path
    else
      render :new
    end
  end

private

  def invitation_params
    params.require(:invitation).permit!
  end
end

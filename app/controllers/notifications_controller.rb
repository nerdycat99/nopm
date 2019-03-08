class NotificationsController < ApplicationController

  skip_before_action :verify_authenticity_token

  before_action :authenticate_user!

  def index
    @notifications = Notification.where(:recipient => current_user).unread
    # render json: Notification.where(:recipient => current_user).unread
  end


  # not used but useful!!!
  def mark_as_read
  #  @notifications = Notification.where(:recipient => current_user).unread
    notification = Notification.find(params[:id])
    notification.update_all(read_at: Time.zone.now)
  #  @notifications.update_all(read_at: Time.zone.now)
    render json: {success: true}
  end

  def update
    @notification = Notification.find(params[:id])
    @notification.read_at = Time.zone.now
    @notification.save
    render json: {success: true}
  end


  private

  def notification_params
    params.require(:notification).permit(:read_at)
  end



end

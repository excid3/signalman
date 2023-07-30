class MainController < ApplicationController
  before_action :current_user

  def index
  end

  def send_mail
    UserMailer.notification.deliver
    head :ok
  end

  def enqueue_mail
    UserMailer.notification.deliver_later
    head :ok
  end
end

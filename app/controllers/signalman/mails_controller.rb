module Signalman
  class MailsController < ApplicationController
    def index
      @events = Event.mails.recent_first
    end

    def show
      @event = Event.mails.find(params[:id])
    end
  end
end

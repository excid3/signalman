module Signalman
  class RequestsController < ApplicationController
    def index
      @events = Event.requests.recent_first
    end

    def show
      @event = Event.requests.find(params[:id])
    end
  end
end

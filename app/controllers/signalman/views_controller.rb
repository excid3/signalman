module Signalman
  class ViewsController < ApplicationController
    def index
      @events = Event.views.recent_first
    end

    def show
      @event = Event.views.find(params[:id])
    end
  end
end

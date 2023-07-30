module Signalman
  class JobsController < ApplicationController
    def index
      @events = Event.jobs.recent_first
    end

    def show
      @event = Event.jobs.find(params[:id])
    end
  end
end

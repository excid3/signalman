module Signalman
  class QueriesController < ApplicationController
    def index
      @events = Event.queries.recent_first
    end

    def show
      @event = Event.queries.find(params[:id])
    end
  end
end

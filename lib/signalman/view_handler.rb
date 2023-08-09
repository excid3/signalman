require "signalman/base_handler"

module Signalman
  class ViewHandler < BaseHandler
    def skip?
      event.payload[:identifier].include?("app/views/signalman/")
    end
  end
end

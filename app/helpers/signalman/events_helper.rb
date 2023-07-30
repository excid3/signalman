module Signalman
  module EventsHelper
    def signalman_path_for(event)
      block = Signalman.events.find{ |key, _| key.match? event.name }.last[:path]
      instance_exec event, &block
    end

    def badge_for_request_duration(duration, &block)
      if duration <= 200
        tag.span "#{duration.round}ms", class: "bg-gray-100 text-gray-800 px-2 py-1 rounded text-xs"
      elsif duration <= 500
        tag.span "#{duration.round}ms", class: "bg-yellow-100 text-yellow-800 px-2 py-1 rounded text-xs"
      else
        tag.span "#{duration.round}ms", class: "bg-red-100 text-red-800 rounded px-2 py-1 text-xs"
      end
    end
  end
end

module Signalman
  class BaseHandler
    attr_reader :current_time, :event

    def self.call(event)
      current_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :float_millisecond)
      new(event, current_time).start
    end

    def initialize(event, current_time)
      @event, @current_time = event, current_time
    end

    def start
      process unless skip?
    end

    def process
      create_event
    end

    def skip?
      false
    end

    def create_event(payload = nil)
      payload ||= event.payload

      Event.create(
        name: event.name,
        started_at: started_at,
        finished_at: finished_at,
        duration: event.duration,
        payload: payload
      )
    rescue ActiveRecord::StatementInvalid => e
      Rails.logger.error "[Signalman] #{e.message}"
    end

    # Time measure since system boot with
    # Process.clock_gettime(Process::CLOCK_MONOTONIC, :float_millisecond)
    def started_at
      Time.current - ((current_time - event.time) / 1_000)
    end

    def finished_at
      Time.current - ((current_time - event.end) / 1_000)
    end
  end
end

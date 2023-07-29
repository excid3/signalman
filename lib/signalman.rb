require "signalman/version"
require "signalman/engine"

module Signalman
  class BaseHandler
    attr_reader :event

    def self.call(event)
      new(event).process
    end

    def initialize(event)
      @event = event
    end

    def process
      create_event
    end

    def create_event(payload = nil)
      payload ||= event.payload

      Event.create(
        name: event.name,
        started_at: started_at,
        finished_at: finished_at,
        payload: payload.merge(duration: event.duration.round)
      )
    end

    # Time measure since system boot with
    # Process.clock_gettime(Process::CLOCK_MONOTONIC, :float_millisecond)
    def started_at
      Time.current - ((current_time - event.time) / 1_000)
    end

    def finished_at
      Time.current - ((current_time - event.end) / 1_000)
    end

    def current_time
      Process.clock_gettime(Process::CLOCK_MONOTONIC, :float_millisecond)
    end
  end

  class ActionHandler < BaseHandler
    def process
      headers = {}
      headers = event.payload.fetch(:headers, {}).each do |name, value|
        headers[name] = value if name.start_with?("HTTP")
        headers[name] = value if ActionDispatch::Http::Headers::CGI_VARIABLES.include?(name)

        [
          "action_dispatch.request_id"
        ].each do |header_name|
          headers[name] = value if name == header_name
        end
      end

      create_event event.payload.slice(
          :method,
          :path,
          :controller,
          :action,
          :params,
          :format,
          :status,
          :db_runtime,
          :view_runtime
        )#.merge(headers: headers)
    end
  end

  class ViewHandler < BaseHandler
  end

  cattr_accessor :events, default: {
    "process_action.action_controller" => {handler: ActionHandler},
    "render_view.action_view" => {handler: ViewHandler},
    "render_partial.action_view" => {handler: ViewHandler},
    "render_collection.action_view" => {handler: ViewHandler},
    "render_layout.action_view" => {handler: ViewHandler},
  }

  def self.register_watchers
    events.each do |event_name, options|
      options[:subscriber] = add_watcher event_name, options[:handler]
    end
  end

  def self.add_watcher(event_name, handler)
    ActiveSupport::Notifications.subscribe event_name, handler
  end
end

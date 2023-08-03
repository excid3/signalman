require "signalman/version"
require "signalman/engine"

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

  class ActionHandler < BaseHandler
    def process
      headers = {}
      event.payload.fetch(:headers, {}).each do |name, value|
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
        ).merge(headers: headers)
    end

    def skip?
      event.payload[:controller].start_with?("Signalman::")
    end
  end

  class ViewHandler < BaseHandler
    def skip?
      event.payload[:identifier].include?("app/views/signalman/")
    end
  end

  class QueryHandler < BaseHandler
    def skip?
      ["SCHEMA", "TRANSACTION", "ActiveRecord::SchemaMigration", "Signalman::"].include?(event.payload[:name])
    end

    def process
      create_event event.payload.except(:connection)
    end
  end

  class MailHandler < BaseHandler
  end

  class JobHandler < BaseHandler
    def process
      job = event.payload[:job]
      create_event(
        class: job.class.name,
        id: job.job_id,
        enqueued_at: job.enqueued_at,
        scheduled_at: scheduled_at(event),
        queue_name: queue_name(event),
        args: args_info(job)
      )
    end

    # From ActiveJob::LogSubscriber
    def queue_name(event)
      # Rails 7.1 -> ActiveJob.adapter_name(event.payload[:adapter]) + "(#{event.payload[:job].queue_name})"
      event.payload[:adapter].class.name.demodulize.remove("Adapter") + "(#{event.payload[:job].queue_name})"
    end

    def args_info(job)
      if job.class.log_arguments? && job.arguments.any?
        " with arguments: " +
          job.arguments.map { |arg| format(arg).inspect }.join(", ")
      else
        ""
      end
    end

    def format(arg)
      case arg
      when Hash
        arg.transform_values { |value| format(value) }
      when Array
        arg.map { |value| format(value) }
      when GlobalID::Identification
        arg.to_global_id rescue arg
      else
        arg
      end
    end

    def scheduled_at(event)
      return unless event.payload[:job].scheduled_at
      Time.at(event.payload[:job].scheduled_at).utc
    end
  end

  cattr_accessor :events, default: {
    "process_action.action_controller" => {
      handler: ActionHandler,
      path: ->(event) { request_path(event) }
    },
    /^\w+\.action_view/ => {
      handler: ViewHandler,
      path: ->(event) { view_path(event) }
    },
    "sql.active_record" => {
      handler: QueryHandler,
      path: ->(event) { query_path(event) }
    },
    "deliver.action_mailer" => {
      handler: MailHandler,
      path: ->(event) { mail_path(event) }
    },
    /^\w+\.active_job/ => {
      handler: JobHandler,
      path: ->(event) { job_path(event) }
    }
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

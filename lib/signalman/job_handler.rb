require "signalman/base_handler"

module Signalman
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
        begin
          arg.to_global_id
        rescue
          arg
        end
      else
        arg
      end
    end

    def scheduled_at(event)
      return unless event.payload[:job].scheduled_at
      Time.at(event.payload[:job].scheduled_at).utc
    end
  end
end

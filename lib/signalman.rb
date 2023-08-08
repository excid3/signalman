require "signalman/version"
require "signalman/engine"

require "signalman/action_handler"
require "signalman/job_handler"
require "signalman/mail_handler"
require "signalman/query_handler"
require "signalman/view_handler"

module Signalman
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

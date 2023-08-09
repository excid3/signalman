require "signalman/base_handler"

module Signalman
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
end

require "signalman/base_handler"

module Signalman
  class QueryHandler < BaseHandler
    IGNORED_QUERIES = [
      "SCHEMA",
      "TRANSACTION",
      "ActiveRecord::SchemaMigration",
      "ActiveRecord::InternalMetadata",
      /^Signalman/
    ]

    # CREATE_TABLE queries have nil for `name`
    def skip?
      return if event.payload[:name].blank?
      IGNORED_QUERIES.any? { |q| q.match? event.payload[:name] }
    end

    def process
      create_event event.payload.except(:connection)
    end
  end
end

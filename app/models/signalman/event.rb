class Signalman::Event < ApplicationRecord
  validates :name, presence: true

  scope :requests, -> { where(name: "process_action.action_controller") }
  scope :mails, -> { where(name: "deliver.action_mailer") }
  scope :queries, -> { where(name: "sql.active_record") }
  scope :views, -> {
    where(name: [
      "render_template.action_view",
      "render_partial.action_view",
      "render_collection.action_view",
      "render_layout.action_view"
    ])
  }
  scope :jobs, -> {
    where(name: [
      "enqueue_at.active_job",
      "enqueue.active_job",
      "perform.active_job",
      "perform_start.active_job",
      "discard.active_job"
    ])
  }

  scope :recent_first, -> { order(created_at: :desc) }
end

class Signalman::Event < ApplicationRecord
  scope :requests, ->{ where(name: "process_action.action_controller") }
  scope :views, ->{
    where(name: [
      "render_template.action_view",
      "render_partial.action_view",
      "render_collection.action_view",
      "render_layout.action_view",
    ])
  }

  scope :recent_first, ->{ order(created_at: :desc) }
end

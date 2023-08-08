module Signalman
  class Engine < ::Rails::Engine
    isolate_namespace Signalman

    initializer "signalman.register_watchers" do
      Signalman.register_watchers
    end

    # helpers must be accessible anywhere for Turbo broadcasts
    initializer "signalman.helpers" do
      ActiveSupport.to_prepare :action_controller do
        helper Signalman::EventsHelper
      end
    end
  end
end

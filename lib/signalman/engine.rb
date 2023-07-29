module Signalman
  class Engine < ::Rails::Engine
    isolate_namespace Signalman
    initializer "watchers" do
      Signalman.register_watchers
    end
  end
end

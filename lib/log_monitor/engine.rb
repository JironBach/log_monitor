if defined? Rails
  module LogMonitor
    class Engine < ::Rails::Engine
      isolate_namespace LogMonitor
    end
  end
end

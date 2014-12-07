require 'log_monitor'

class LogMonitorRunner
  def self.execute
    Thread.new do
      config = YAML.load_file('config/log-monitor.yml')['development']
      alerter = LogMonitor::Factory.get(config)
      alerter.monitor
    end
    sleep
  end
end


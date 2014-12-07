require 'log_monitor'

Thread.new do
  config = YAML.load_file('config/log-monitor.yml')['development']
  alerter = LogMonitor::LogMonitorFactory.get(config)
  alerter.monitor
end
sleep

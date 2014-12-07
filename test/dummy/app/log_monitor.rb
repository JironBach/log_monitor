require 'log_monitor'

Thread.new do
  config = YAML.load_file('config/log-monitor.yml')['development']
  puts config.inspect
  alerter = LogMonitor::LogMonitorFactory.get(config)
  puts alerter.inspect
  alerter.monitor
end
while true do end

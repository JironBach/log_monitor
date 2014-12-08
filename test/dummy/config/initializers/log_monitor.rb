Thread.new do
  config_file = Rails.root.join('config', 'log-monitor.yml')
  config = YAML.load_file(config_file)[Rails.env]
  alerter = LogMonitor::Factory.get(config)
  alerter.monitor
end

require 'log_monitor'

Thread.new do
  alerter = LogMonitor::FileAlerter.new
  alerter.set_words(['Completed'])
  alerter.set_in('log/development.log')
  alerter.set_out('tmp/log-monitor.log')
  alerter.monitor
end
while true
end

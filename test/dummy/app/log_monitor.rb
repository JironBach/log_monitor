require 'log_monitor'

#Thread.new do
  alerter = LogMonitor::Alerter.new
  alerter.set_words(['Completed'])
  alerter.set_in('log/development.log')
  alerter.monitor
#end
#while true
#end

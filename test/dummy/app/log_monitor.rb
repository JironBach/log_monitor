require 'log_monitor'

alerter = LogMonitor::Alerter.new
alerter.set_words(['Completed'])
alerter.set_in('log/development.log')
alerter.monitor

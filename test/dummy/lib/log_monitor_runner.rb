require 'log_monitor'
require 'log_monitor/alerter'

class LogMonitorRunner
  def self.execute
    alerter = LogMonitor::Alerter.new
    alerter.set_words(['Completed'])
    alerter.set_in('log/development.log')
    alerter.monitor
  end
end


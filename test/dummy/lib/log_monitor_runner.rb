require 'log_monitor'

class LogMonitorRunner
  def self.execute
    alerter = LogMonitor::Alerter.new
    alerter.set_words(['Completed'])
    alerter.set_in('log/development.log')
    alerter.monitor
  end
end


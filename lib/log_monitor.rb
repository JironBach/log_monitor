#require "log_monitor/engine"
require "log_monitor/alerter"

module LogMonitor
  class LogMonitorFactory
    def self.get(config)
      puts 'called get'
      alerter = self.get_alerter(config)
      puts "#{alerter.inspect}"
      alerter.set_in(config['monitor']['target'])
      alerter.set_words(['Completed'])
      alerter
    end

    def self.get_alerter(config)
      puts config.inspect
      if config['method'] == 'email'
        alerter = LogMonitor::MailAlerter.new
        alerter.set_email(config['email'])
      elsif config['method'] == 'webhook'
        alerter = LogMonitor::WebHookAlerter.new
      elsif config['method'] == 'file'
        alerter = LogMonitor::FileAlerter.new
        alerter.set_out(config['file'])
      else
        alerter = LogMonitor::Alerter.new
      end
      alerter
    end

  end
end

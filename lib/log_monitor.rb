require "log_monitor/engine" if defined? Rails
require "log_monitor/alerter"

module LogMonitor
  class Factory
    def self.get(config)
      alerter = self.get_alerter(config)
      alerter.set_in(config['monitor']['target'])
      alerter.set_words(config['monitor']['words'])
      alerter
    end

    def self.get_alerter(config)
      if config['method'] == 'email'
        alerter = LogMonitor::EmailAlerter.new
        alerter.set_email(config['email'])
      elsif config['method'] == 'webpost'
        alerter = LogMonitor::WebPostAlerter.new
        alerter.set_webpost(config['webpost'])
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

class MonitorController < ApplicationController

  def webhook
    alerter = LogMonitor::Alerter.new
  end

end

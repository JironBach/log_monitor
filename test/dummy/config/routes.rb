Rails.application.routes.draw do

  mount LogMonitor::Engine => "/log_monitor"
end

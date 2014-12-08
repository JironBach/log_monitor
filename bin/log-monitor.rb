#!/usr/bin/env ruby
#require 'log_monitor'

if ARGV[0] == '-c'
  puts <<EOF
monitor:
  target: /tmp/log/development.log
  words:
    - Completed 500 Internal Server Error
    - No route matches
method: file # or console or email or webpost
file: /tmp/log-monitor.log
webpost: http://localhost:3000/monitor/post # ignored which not selected as method
email: # ignored which not selected as method
  to:
    - *@*.com
  from: *@gmail.com
  subject: Alert! *.com Error occured!
  address: smtp.gmail.com
  port: 587
  user_name: *@gmail.com
  password: [password]
EOF
elsif !ARGV[0].nil? && File.exist?(ARGV[0])
  Thread.new do
    config = YAML.load_file(ARGV[1])
    alerter = LogMonitor::Factory.get(config)
    alerter.monitor
  end
  sleep
else
  puts <<EOF
(none or other) : show help (this message)
-c : show example of config file. Please use rediret.
[config file] : run monitoring log
EOF
end

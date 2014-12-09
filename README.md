# LogMonitor #
## Monitoring web server's log. And raise alert with email, webpost, file, or console. ##

### Install ###
* Add

```ruby
gem "log-monitor"
```
  to Gemfile.

### Usage ###
#### As RAILS plugin ####
* Create config/log-monitor.yml
```
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
```

* Create config/initializers/log-monitor.rb
```
require 'log_monitor'

Thread.new do
  config_file = Rails.root.join('config', 'log-monitor.yml')
  config = YAML.load_file(config_file)#[Rails.env]
  alerter = LogMonitor::Factory.get(config)
  alerter.monitor
end
```

#### As standalone application ####
* Create log-monitor.yml
```
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
```

* Run `log-monitor log-monitor.yml`

### System requirement ###
* Ruby 2.0 or later.
* RoR 4.1 or later.
* tlsmail.

License
----------
Copyright &copy; 2014 Jun’ya Shimoda(JironBach)
Licensed under the [MIT license][MIT].

[MIT]: http://www.opensource.org/licenses/mit-license.php

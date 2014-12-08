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
* Run `log-monitor -c > config/log-monitor.yml` and edit it.
* Run `log-monitor -i > config/initializers/log-monitor.rb`.
#### As standalone application ####
* Run `log-monitor -c > log-monitor.yml` and edit it.
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

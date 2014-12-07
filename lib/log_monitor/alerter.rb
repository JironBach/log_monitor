module LogMonitor
  class Alerter
    def initialize
      #debug
      File.open('/tmp/log_monitor.log', 'w') do |file|
        file.puts 'LogMonitor new'
        file.puts Time.now
      end
      clear_alert
    end

    def set_in(io_in)
      @io_in = io_in
      if io_in == 'STRERR'
        @in = $stderr
      elsif io_in == 'STROUT'
        @in = $stdout
      else
        #FileUtils.touch(io_in) unless File.exists?(io_in)
        @in = File.open(io_in, 'r')
      end
      if @last_line == 0
        @in.seek(0, IO::SEEK_END)
      else
        @last_line.times @in.gets
      end
    end

    def set_words(words)
      @words = words
    end

    def monitor
      begin
        while true
          revival_monitor
        end
      ensure
        @in.close
      end
    end

    def check_words
      is_alert = false
      @words.each do | word |
        if @alert_body.include? word
          is_alert = true
          break
        end
      end
      if is_alert
        alert
      end
      clear_alert
    end

    def clear_alert
      @alert_body = ''
      @blank_line_count = 0
    end

    def alert
      #debug
      File.open('/tmp/log_monitor.log', 'a') do |file|
        file.puts @alert_body
      end
      clear_alert
    end

    protected

    def revival_monitor
      return if @in.nil?
      while true
        line = @in.gets
        @alert_body += "#{line}"
        if line.blank?
          @blank_line_count += 1
        else
          @blank_line_count = 0
        end
        check_words if @blank_line_count >= 2
        @last_line = @in.lineno
        set_in(@io_in) if @in.eof
      end
    end

  end

  class MailAlerter < Alerter
  end

  class WebHookAlerter < Alerter
  end

end


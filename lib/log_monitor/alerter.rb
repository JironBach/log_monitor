module LogMonitor
  class Alerter
    def initialize
      clear_alert
    end

    def set_in(io_in)
      @io_in = io_in
      FileUtils.touch(io_in) unless File.exists?(io_in)
      @in = File.open(io_in, 'r')
    end

    def set_words(words)
      @words = words
    end

    def monitor
      @in.seek(0, IO::SEEK_END)
      begin
          revival_monitor
      ensure
        @in.close
      end
    end

    def check_words
      is_alert = false
      @words.each do | word |
        if @alert_body.match(/#{word}/)
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
      begin
        $stdout.puts @alert_body
      rescue => e
        $stderr.puts "LogMonitor error"
        $stderr.puts e.message
        2.times $stderr.puts
      end
      clear_alert
    end

    protected

    def revival_monitor
      return if @in.nil?
      while true
        sleep(1) if @in.eof
        line = @in.gets
        @alert_body += "#{line}"
        if line.blank?
          @blank_line_count += 1
        else
          @blank_line_count = 0
        end
        check_words if @blank_line_count >= 2
      end
    end

  end


  class FileAlerter < Alerter
    def set_out(filename)
      @filename = filename
    end

    def alert
      begin
        File.open(@filename, 'a') do | io_out |
          io_out.puts @alert_body
        end
      rescue => e
        $stderr.puts "LogMonitor error"
        $stderr.puts e.message
        2.times $stderr.puts
      end
      clear_alert
    end

  end


  require 'mail'
  class EmailAlerter < Alerter
    def set_email(config)
      @config = config
      @smtp_settings = {
        address: config['address'],
        port: config['port'],
        user_name: config['user_name'],
        password: config['password'],
        domain: config['domain'],
        authentication: config['authentication'].nil? ? :plain : config['authentication'],
        enable_starttls_auto: true
      }
    end

    def alert
      begin
        mail = Mail.new
        mail[:from] = @config['from']
        mail[:to] = @config['to']
        mail.subject = @config['subject']
        smtpserver = Net::SMTP.new(@smtp_settings[:address], @smtp_settings[:port])
        smtpserver.enable_tls(OpenSSL::SSL::VERIFY_NONE)
        smtpserver.start(@smtp_settings[:domain], @smtp_settings[:user_name], @smtp_settings[:password], :login) do |smtp|
          mail.body = @alert_body
          smtp.send_message(mail.encoded, mail.from, mail.to)
        end
      rescue => e
        $stderr.puts "LogMonitor error"
        $stderr.puts e.message
        2.times $stderr.puts
      end
      clear_alert
    end

  end


  class WebPostAlerter < Alerter
    def set_webpost(config)
      @url = config
    end

    def alert
      begin
        Net::HTTP.post_form(URI.parse(@url), { checker: 'logmonitor-webpost-log', body: "#{ @alert_body }"})
      rescue => e
        $stderr.puts "LogMonitor error"
        $stderr.puts e.message
        2.times $stderr.puts
      end
      clear_alert
    end

    def check_words
      is_alert = false
      @words.each do | word |
        if @alert_body.match(/#{word}/) && !@alert_body.include?('logmonitor-webpost-log')
          is_alert = true
          break
        end
      end
      if is_alert
        alert
      end
      clear_alert
    end

  end


end


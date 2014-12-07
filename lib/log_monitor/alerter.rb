module LogMonitor
  class Alerter
    def initialize
      clear_alert
    end

    def set_in(io_in)
      @io_in = io_in
      if io_in == 'STRERR'
        @in = $stderr
      elsif io_in == 'STROUT'
        @in = $stdout
      else
        FileUtils.touch(io_in) unless File.exists?(io_in)
        @in = File.open(io_in, 'r')
      end
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


  require 'net/smtp'
  require 'mail'
  class MailAlerter < Alerter
    def set_email(config)
      @smtp_settings = {
        address: config['address'],
        port: config['port'],
        user_name: config['user_name'],
        password: config['password'],
        domain: config['domain'],
        authentication: config['authentication'].nil? ? :plain : config['authentication'],
        enable_starttls_auto: true
      }
      @mail = Mail.new
      @mail[:from] = config['from']
      @mail[:to] = 'jironbach@gmail.com'#config['from']
      @mail.subject = config['subject']
    end

    def alert
      begin
        smtpserver = Net::SMTP.new(@smtp_settings[:address], @smtp_settings[:port])
        #smtpserver.enable_tls(OpenSSL::SSL::VERIFY_NONE)
        smtpserver.start(@smtp_settings[:domain], @smtp_settings[:user_name], @smtp_settings[:password], :login) do |smtp|
          smtp.send_message(@alert_body, mail.from, mail.to)
        end
      rescue => e
        $stderr.puts "LogMonitor error"
        $stderr.puts e.message
        2.times $stderr.puts
      end
      clear_alert
    end

  end


  class WebHookAlerter < Alerter
  end

end


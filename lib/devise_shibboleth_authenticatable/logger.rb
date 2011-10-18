module DeviseShibbolethAuthenticatable

  class Logger    
    def self.send(message, logger = Rails.logger)
      if ::Devise.shibboleth_logger
        logger.add 0, "  \e[36mShibboleth:\e[0m #{message}"
      end
    end
  end

end

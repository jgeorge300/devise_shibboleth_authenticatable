require 'devise_shibboleth_authenticatable/strategy'

module Devise
  module Models
    module ShibbolethAuthenticatable
      extend ActiveSupport::Concern

      # Need to determine why these need to be included
      included do
        attr_reader :password, :current_password
        attr_accessor :password_confirmation
      end

      def update_with_password(params={})
        params.delete(:current_password)
        self.update_without_password(params)
      end	

      def update_without_password(params={})
        params.delete(:password)
        params.delete(:password_confirmation)

        result = update_attributes(params)
        result
      end

      module ClassMethods
        def authenticate_with_shibboleth(env)

          auth_key = self.authentication_keys.first
          auth_key_value = (self.case_insensitive_keys || []).include?(auth_key) ? env['eppn'].downcase : env['eppn']

          resource = where(auth_key => auth_key_value).first

          if (resource.nil? && !Devise.shibboleth_create_user)
            logger.info("User(#{auth_key_value}) not found.  Not configured to create the user.")
            return nil 
          end

	  if (resource.nil? && Devise.shibboleth_create_user)
            logger.info("Creating user(#{auth_key_value}).")
	    resource = new
            save_user_shibboleth_headers(resource, env)
            resource.save
          end
          resource
	end

        def find_for_shibb_authentication(conditions)
          find_for_authentication(conditions)
        end

        private
        def save_user_shibboleth_headers(user, env)
          shib_config = YAML.load(ERB.new(File.read(::Devise.shibboleth_config || "#{Rails.root}/config/shibboleth.yml")).result)[Rails.env]
          shib_config['user-mapping'].each do |model, header|
            logger.info("Saving #{env[header]} to #{model}")
            field = "#{model}="
            value = env[header]
            user.send(field, value.to_s) 
          end
        end
      end
    end
  end
end

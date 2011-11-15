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

      module ClassMethods
        def authenticate_with_shibboleth(env)
	  resource = User.find_by_email(env['eppn'])

	  resource = User.new() if (resource.nil?)
          return nil unless resource

          SHIBBOLETH_HEADER_MAPPING['user-mapping'].each do |model, header|
            field = "#{model}="
            value = env[header]
            resource.send(field, value.to_s) 
          end

          resource.save
          resource
	end

        def find_for_shibb_authentication(conditions)
          find_for_authentication(conditions)
        end
      end
    end
  end
end

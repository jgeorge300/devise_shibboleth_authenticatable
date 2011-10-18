require 'devise_shibboleth_authenticatable/strategy'

module Devise
  module Models
    module ShibbolethAuthenticatable
      extend ActiveSupport::Concern

      included do
        attr_reader :password, :current_password
        attr_accessor :password_confirmation
      end

      module ClassMethods
        def authenticate_with_shibboleth(env)
	  resource = User.find_by_email(env['eppn'])

	  resource = new() if (resource.nil?)
          return nil unless resource
          
          resource.email = env['eppn']	 
          resource.name = env['LAST-NAME'] 
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

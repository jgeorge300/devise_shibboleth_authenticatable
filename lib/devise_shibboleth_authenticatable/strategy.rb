require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class ShibbolethAuthenticatable < Authenticatable
      def valid?
         request.env['eppn']
      end

      def authenticate!
	if resource = mapping.to.authenticate_with_shibboleth(request.env)
	  success!(resource)
        else 
	  fail!(:invalid)
        end
      end

    end
  end
end

Warden::Strategies.add(:shibboleth_authenticatable, Devise::Strategies::ShibbolethAuthenticatable)

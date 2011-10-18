require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class ShibbolethAuthenticatable < Authenticatable
      def valid?
         request.env['eppn']
      end

      def authenticate!
	eppn = read_shibbolethvars(params)
        
	if resource = mapping.to.authenticate_with_shibboleth(request.env)
	  success!(resource)
        else 
	  fail!(:invalid)
        end

      end

      protected
      
      def read_shibbolethvars(params)

	eppn = request.env['eppn']
	lname = request.env['LAST-NAME']
	fname = request.env['FIRST-NAME']
        eppn
        
      end

    end
  end
end

Warden::Strategies.add(:shibboleth_authenticatable, Devise::Strategies::ShibbolethAuthenticatable)

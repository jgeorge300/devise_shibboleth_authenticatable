class Devise::ShibbolethSessionsController < Devise::SessionsController
  unloadable
  
  def new
    resource = build_resource
    shib_config = YAML.load(ERB.new(File.read(::Devise.shibboleth_config || "#{Rails.root}/config/shibboleth.yml")).result)[Rails.env]

    destination = request.protocol
    destination << request.host
    destination << ":#{request.port.to_s}" unless request.port == 80
    destination << after_sign_in_path_for(resource)
    
    shib_login_url = shib_config['shibb_login_url'] + "?target=" + URI.escape(destination, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))

    redirect_to(shib_login_url)
  end

  def destroy
    # Can't fully log out from Shibboleth until the browser is closed.
  end
end

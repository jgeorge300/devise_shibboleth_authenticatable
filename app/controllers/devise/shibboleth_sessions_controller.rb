class Devise::ShibbolethSessionsController < Devise::SessionsController
  unloadable
  
  def new
    if request.env['eppn']
      authenticate_with_shibboleth request.env
    end

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
    super
  end

  private
  # Repeating Myself.  Need to move to a helper
  def authenticate_with_shibboleth(env)

    resource = User.find_by_email(env['eppn'])

    if (!resource.nil? && !Devise.shibboleth_create_user)
      logger.warn("User(#{env['eppn']}) not found.  Not configured to create the user.")
      return resource
    end

    if (resource.nil? && Devise.shibboleth_create_user)
      logger.fatal("Creating user(#{env['eppn']}).")
      resource = User.new()
    end
    return nil unless resource

    save_user_shibboleth_headers(resource, env)

    resource.save
    resource
  end

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

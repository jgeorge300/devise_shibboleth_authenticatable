module DeviseShibbolethAuthenticatable
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    
    class_option :user_model, :type => :string, :default => "user", :desc => "Model to update"
    class_option :update_model, :type => :boolean, :default => true, :desc => "Update model to change from database_authenticatable to shibboleth_authenticatable"
    class_option :add_rescue, :type => :boolean, :default => true, :desc => "Update Application Controller with resuce_from for DeviseShibbolethAuthenticatable::ShibbolethException"
    class_option :advanced, :type => :boolean, :desc => "Add advanced config options to the devise initializer"
    
    
    def create_shibboleth_config
      copy_file "shibboleth.yml", "config/shibboleth.yml"
    end
    
    def create_default_devise_settings
      inject_into_file "config/initializers/devise.rb", default_devise_settings, :after => "Devise.setup do |config|\n"   
    end
    
    def update_user_model
      gsub_file "app/models/#{options.user_model}.rb", /:database_authenticatable/, ":shibboleth_authenticatable" if options.update_model?
    end
    
    def update_application_controller
      inject_into_class "app/controllers/application_controller.rb", ApplicationController, rescue_from_exception if options.add_rescue?
    end
    
    private
    
    def default_devise_settings
      settings = <<-eof
  # ==> Shibboleth Configuration
  # config.shibboleth_logger = true
  # config.shibboleth_create_user = false
  # config.shibboleth_config = "\#{Rails.root}/config/shibboleth.yml"

      eof
      if options.advanced?  
        settings << <<-eof  
  # ==> Advanced Shibboleth Configuration
  
        eof
      end
      
      settings
    end
    
    def rescue_from_exception
      <<-eof
  rescue_from DeviseShibbolethAuthenticatable::ShibbolethException do |exception|
    render :text => exception, :status => 500
  end
      eof
    end
    
  end
end

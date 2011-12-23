ActionDispatch::Routing::Mapper.class_eval do
  protected
  
  def devise_shibboleth_authenticatable(mapping, controllers)
    resource :session, :only => [], :controller => controllers[:shibboleth_sessions], :path => "" do
      get :new, :path => mapping.path_names[:sign_in], :as => "new"
      match :destroy, :path => mapping.path_names[:sign_out], :as => "destroy"
    end
  end
end

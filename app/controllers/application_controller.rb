# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  
  # See ActionController::RequestForgeryProtection for details Uncomment the
  # :secret if you're not using the cookie session store
  protect_from_forgery :secret => '94a045671ab58104501adbe61f796bc0'
  
  # See ActionController::Base for details Uncomment this to filter the contents
  # of submitted sensitive data parameters from your application log (in this
  # case, all fields with names like "password"). filter_parameter_logging
  # :password Be sure to include AuthenticationSystem in Application Controller
  # instead
  include AuthenticatedSystem
  
  protected

  def authorize
    unless global_auth?
      flash[:error] = "unauthorized access"
      redirect_to login_path
    end
  end
  def global_auth?
    current_user.login?
  rescue  
    flash[:error] = 'unauthorized access'
    redirect_to login_path
  end
  helper_method :global_auth?
end

class MainController < ApplicationController
  def index
    @links = {
      :macro=>'/macro',
      :avatar_session=>'/avatar_session',
      :generated=>'/generated',
      :scaffold_test=>'/scaffold_test',
      :callbacks=>'/callbacks',
      :session=>'/session',
      :session_init=>'/session/init',
      :session_second=>'/session/second',
      :session_third=>'/session/third',
      :session_finish=>'/session/finish',
      :sandbox=>'/sandbox',
      :sandbox_init=>'/sandbox/init',
      :sandbox_second=>'/sandbox/second',
      :sandbox_third=>'/sandbox/third',
      :sandbox_finish=>'/sandbox/finish',
      :image_submit=>'/image_submit'
    }
  end

  def finished
    @referring_controller = referring_controller
  end

  def canceled
    @referring_controller = referring_controller
  end

  def referrer_page
  end
  
  private
  def referring_controller
    referer = request.env['HTTP_REFERER']    
    ActionController::Routing::Routes.recognize_path(URI.parse(referer).path)[:controller]
  end

end

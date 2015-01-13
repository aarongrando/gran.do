module ApplicationHelper

  def controller_action
    "#{params[:controller]}##{params[:action]}"
  end

  def offline_mode?
    # I'm using this to disable any third-party-loaded scripts (fonts, etc.)
    # while developing offline.
    if Rails.env == 'production'
      return false # Always return false in production
    else
      return true # Manual toggle for local dev; true = offline mode
    end
  end
  
end

module ApplicationHelper

  def controller_action
    "#{params[:controller]}##{params[:action]}"
  end

  def offline_mode?
    true # manual toggle for developing offline
  end
  
end

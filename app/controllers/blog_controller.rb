class BlogController < ApplicationController
  
  def whoa 
    
  end
  
  def draft
    @draft_path = "blog/drafts/" + params[:file]
  end
  
end

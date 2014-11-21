class BlogController < ApplicationController
  
  def index
  	
  end

  def whoa 
    
  end
  
  def draft
    @draft_path = "blog/drafts/" + params[:file]
  end
  
end

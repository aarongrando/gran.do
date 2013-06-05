class HomeController < ApplicationController

  require 'open-uri'
  require 'nokogiri' 
  
  def index
    if RssStore.last.present?
      @rss = SimpleRSS.parse RssStore.last.xml 
    else
      @rss = SimpleRSS.parse open('https://medium.com/feed/@grrrando/')
      RssStore.create({xml: @rss.source})
    end
    if @rss.present?
      @rss_images = Array.new
      @rss.items.each do |item|
        item_dom = Nokogiri::HTML(item.description)
        if item_dom.present?
          img = item_dom.css('img')
          if img.present?
            @rss_images << img.attribute('src')
          end
        end
      end
    end
  end
end

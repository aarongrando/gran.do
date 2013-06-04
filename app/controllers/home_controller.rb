class HomeController < ApplicationController

  require 'open-uri'
  require 'nokogiri' 
  
  def index
    if RssStore.last.present?
      @rss = SimpleRSS.parse RssStore.last.xml 
    else
      @rss = SimpleRSS.parse open('https://medium.com/feed/@grrrando/')
      RssStore.create({xml: pull.source})
    end
    @rss_images = Array.new
    @rss.items.each do |item|
      item_dom = Nokogiri::HTML(item.description)
      @rss_images << item_dom.css('img').attribute('src')
    end
  end
end

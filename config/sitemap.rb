# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.example.com"

SitemapGenerator::Sitemap.create do
  SitemapGenerator::Sitemap.default_host = 'http://gran.do'
  
  routes = Rails.application.routes.routes.map do |route|
    {alias: route.name, path: route.path.spec.to_s, controller: route.defaults[:controller], action: route.defaults[:action]}
  end
  
  banned_controllers = ["rails/info", nil]
  routes.reject! {|route| banned_controllers.include?(route[:controller])}
  
  routes.reject! {|route| route[:path] == '/'}
  
  routes.each {|route| add route[:path][0..-11]}
  
end

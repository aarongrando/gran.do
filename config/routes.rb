Grrrando::Application.routes.draw do
  # The priority is based upon order of creation:
  # earlier in this file -> higher priority.

  root to: 'home#index'

  get '/cv',      to: 'home#cv',    as: :cv
  get '/purpose', to: 'blog#about', as: :purpose
  
  ['thinks','says','b','blog'].each do |path|
    get "/#{path}/fall",                                              to: 'blog#fall',           as: :blog_fall
    get "/#{path}/finishing",                                         to: 'blog#finishing',      as: :blog_finishing
    get "/#{path}/this-website",                                      to: 'blog#about',          as: :blog_about
    get "/#{path}/lets-hang-out",                                     to: 'blog#hang_out',       as: :blog_hang_out
    get "/#{path}/three-from-last-week",                              to: 'blog#last_week',      as: :blog_last_week
    get "/#{path}/intro-to-heroku-addons",                            to: 'blog#heroku',         as: :blog_heroku
    get "/#{path}/for-the-love-of-the-url",                           to: 'blog#url',            as: :blog_url
    get "/#{path}/1-line-productivity-hack",                          to: 'blog#productivity',   as: :blog_productivity
    get "/#{path}/the-internet-is-a-mirror",                          to: 'blog#mirror',         as: :blog_mirror
    get "/#{path}/engineers-and-advertising",                         to: 'blog#engineers',      as: :blog_engineers
    get "/#{path}/eating-your-own-final-boss",                        to: 'blog#final_boss',     as: :blog_final_boss
    get "/#{path}/complexity-equals-features-squared",                to: 'blog#complexity',     as: :blog_complexity
    get "/#{path}/what-ad-agencies-job-openings-are-really-saying",   to: 'blog#job_openings',   as: :blog_job_openings
    
  end

end

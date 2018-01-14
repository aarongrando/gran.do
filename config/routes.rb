
Grrrando::Application.routes.draw do
  # The priority is based upon order of creation:
  # earlier in this file -> higher priority.

  root to: 'home#index'

  get '/federation',  to: 'stellar#federation'
  get '/cv',          to: 'home#cv',     as: :cv
  get '/purpose',     to: 'blog#about',  as: :purpose
  get '/blog',        to: 'blog#index',  as: :blog_index
  
  blog_paths = ['thinks','says','b','blog']
  blog_paths.each do |path|
    get "/#{path}/2057",                                              to: 'blog#memories',            as: "#{path}_memories"
    get "/#{path}/fall",                                              to: 'blog#fall',                as: "#{path}_fall"
    get "/#{path}/respre",                                            to: 'blog#respre',              as: "#{path}_respre"
    get "/#{path}/finishing",                                         to: 'blog#finishing',           as: "#{path}_finishing"
    get "/#{path}/anxiety-debt",                                      to: 'blog#anxiety_debt',        as: "#{path}_anxiety_debt"
    get "/#{path}/this-website",                                      to: 'blog#about',               as: "#{path}_about"
    get "/#{path}/lets-hang-out",                                     to: 'blog#hang_out',            as: "#{path}_hang_out"
    get "/#{path}/things-i-like",                                     to: 'blog#things_i_like',       as: "#{path}_things_i_like"
    get "/#{path}/questions-on-growth",                               to: 'blog#questions',           as: "#{path}_questions"
    get "/#{path}/three-from-last-week",                              to: 'blog#last_week',           as: "#{path}_last_week"
    get "/#{path}/intro-to-heroku-addons",                            to: 'blog#heroku',              as: "#{path}_heroku"
    get "/#{path}/for-the-love-of-the-url",                           to: 'blog#url',                 as: "#{path}_url"
    get "/#{path}/1-line-productivity-hack",                          to: 'blog#productivity',        as: "#{path}_productivity"
    get "/#{path}/the-internet-is-a-mirror",                          to: 'blog#mirror',              as: "#{path}_mirror"
    get "/#{path}/engineers-and-advertising",                         to: 'blog#engineers',           as: "#{path}_engineers"
    get "/#{path}/eating-your-own-final-boss",                        to: 'blog#final_boss',          as: "#{path}_final_boss"
    get "/#{path}/complexity-equals-features-squared",                to: 'blog#complexity',          as: "#{path}_complexity"
    get "/#{path}/how-much-does-it-cost-to-sell-stuff-online",        to: 'blog#sell_stuff_online',   as: "#{path}_sell_stuff_online"
    get "/#{path}/what-ad-agencies-job-openings-are-really-saying",   to: 'blog#job_openings',        as: "#{path}_job_openings"
  end
  
  get '/draft/:file', to: 'blog#draft'

end

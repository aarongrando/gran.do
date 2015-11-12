
Grrrando::Application.routes.draw do
  # The priority is based upon order of creation:
  # earlier in this file -> higher priority.

  root to: 'home#index'

  get '/cv',      to: 'home#cv',    as: :cv
  get '/purpose', to: 'blog#about', as: :purpose
  get '/blog',    to: 'blog#index',  as: :blog_index
  
  ['thinks','says','b','blog'].each do |path|
    # get "/#{path}/2057",                                            to: 'blog#memories',            as: :blog_memories
    get "/#{path}/fall",                                              to: 'blog#fall',                as: :blog_fall
    get "/#{path}/respre",                                            to: 'blog#respre',              as: :blog_respre
    get "/#{path}/finishing",                                         to: 'blog#finishing',           as: :blog_finishing
    get "/#{path}/anxiety-debt",                                      to: 'blog#anxiety_debt',        as: :blog_anxiety_debt
    get "/#{path}/this-website",                                      to: 'blog#about',               as: :blog_about
    get "/#{path}/lets-hang-out",                                     to: 'blog#hang_out',            as: :blog_hang_out
    get "/#{path}/things-i-like",                                     to: 'blog#things_i_like',       as: :blog_things_i_like
    get "/#{path}/questions-on-growth",                               to: 'blog#questions',           as: :blog_questions
    get "/#{path}/three-from-last-week",                              to: 'blog#last_week',           as: :blog_last_week
    get "/#{path}/intro-to-heroku-addons",                            to: 'blog#heroku',              as: :blog_heroku
    get "/#{path}/for-the-love-of-the-url",                           to: 'blog#url',                 as: :blog_url
    get "/#{path}/1-line-productivity-hack",                          to: 'blog#productivity',        as: :blog_productivity
    get "/#{path}/the-internet-is-a-mirror",                          to: 'blog#mirror',              as: :blog_mirror
    get "/#{path}/engineers-and-advertising",                         to: 'blog#engineers',           as: :blog_engineers
    get "/#{path}/eating-your-own-final-boss",                        to: 'blog#final_boss',          as: :blog_final_boss
    get "/#{path}/complexity-equals-features-squared",                to: 'blog#complexity',          as: :blog_complexity
    get "/#{path}/how-much-does-it-cost-to-sell-stuff-online",        to: 'blog#sell_stuff_online',   as: :blog_sell_stuff_online
    get "/#{path}/what-ad-agencies-job-openings-are-really-saying",   to: 'blog#job_openings',        as: :blog_job_openings
  end
  
  get '/draft/:file', to: 'blog#draft'

end

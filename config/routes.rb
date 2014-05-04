Grrrando::Application.routes.draw do
  # The priority is based upon order of creation:
  # earlier in this file -> higher priority.

  root to: 'home#index'

  get '/cv',      to: 'home#cv',    as: :cv
  get '/purpose', to: 'blog#about', as: :purpose
  
  get '/blog/fall',                                             to: 'blog#fall',          as: :blog_fall
  get '/blog/finishing',                                        to: 'blog#finishing',     as: :blog_finishing
  get '/blog/this-website',                                     to: 'blog#about',         as: :blog_about
  get '/blog/lets-hang-out',                                    to: 'blog#hang_out',      as: :blog_hang_out
  get '/blog/intro-to-heroku-addons',                           to: 'blog#heroku',        as: :blog_heroku
  get '/blog/1-line-productivity-hack',                         to: 'blog#productivity',  as: :blog_productivity
  get '/blog/engineers-and-advertising',                        to: 'blog#engineers',     as: :blog_engineers
  get '/blog/complexity-equals-features-squared',               to: 'blog#complexity',    as: :blog_complexity
  get '/blog/what-ad-agencies-job-openings-are-really-saying',  to: 'blog#job_openings',  as: :blog_job_openings



end

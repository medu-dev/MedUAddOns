MedUAddOns::Application.routes.draw do

  #this is for testing
  get "comments/show"

  get "disqus/getcomments"

  root to: 'login#login'

  post "login/login_to_casus"
  get "login/login"

end

MedUAddOns::Application.routes.draw do

  #this is for testing
  get "comments/show"

  get "disqus/getcomments"

  root to: 'comments#show'

end

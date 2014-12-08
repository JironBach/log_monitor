Rails.application.routes.draw do
  root 'monitor#raise500'
  post 'monitor/post', to: 'monitor#post'

end

Rails.application.routes.draw do

  match 'auth/:provider/callback', to: 'users#update', via: 'get'
  match 'auth/failure', to: redirect('/'), via: 'get'
  match '/api/toggle' , to: 'users#update_sharing', via: 'post'

  root 'users#update'
  post '/api/echos' => 'echos#create'
  post '/api/users' => 'users#create'

  get '/o/:short_url' => 'echos#expand', as:'expand'

  get 'privacy' => 'support#privacy'

  get   'bug_report' => 'support#new'
  post  'bug_reports' => 'support#create'
  get   'bug_reports' => 'support#thanks'
  get '/bugs', '/bugreport', '/report', 'bug-report', to: redirect('/bug_report')

  get '/termsofservice' => 'support#terms'
  get '/terms', to: redirect('/termsofservice')

end

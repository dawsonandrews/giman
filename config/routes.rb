Giman::Engine.routes.draw do
  get 'presign', to: 'presigned_url#show'
  post 'create', to: 'direct_uploads#create'
end

Giman::Engine.routes.draw do
  get 'presign', to: 'presigned_url#show', as: :presign
  post 'create', to: 'direct_uploads#create', as: :upload
end

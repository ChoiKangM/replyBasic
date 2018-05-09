Rails.application.routes.draw do
  root 'memos#index'
  # Memo
  # Create
  get '/memos/new' => 'memos#new'
  get '/memos/create' => 'memos#create' 
  # Read
  get '/memos/index' => 'memos#index'
  get '/memos/:id/show' => 'memos#show'
  # Update
  get '/memos/:id/edit' => 'memos#edit'
  get '/memos/:id/update' => 'memos#update'
  # Delete
  get '/memos/:id/destroy' => 'memos#destroy'

  # Reply
  # Create
  get '/memos/:memo_id/replies' => 'replies#create'
  # Delete
  get '/memos/:memo_id/replies/:id' => 'replies#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

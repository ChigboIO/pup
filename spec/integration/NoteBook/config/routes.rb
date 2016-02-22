PupApplication.routes.create do
  resources "notes"
  root "pages#index"
  get "/about", to: "pages#about"
end

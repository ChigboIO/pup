require "pup/routing/router"

class RouterFactory < Pup::Routing::Router
  def initialize
    super

    create do
      get "pages/:id/foo", to: "pages#foo"
      root "pages#index"
      resources :pages
    end
  end
end

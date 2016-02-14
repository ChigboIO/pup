module Pup
  module RouteHelpers
    def root(target)
      get("/", to: target)
    end

    def resources(resource, options = {})
      actions = get_required_actions(options)

      # rubocop:disable Metrics/LineLength
      get("/#{resource}", to: "#{resource}#index") if actions.include?(:index)
      get("/#{resource}/new", to: "#{resource}#new") if actions.include?(:new)
      post("/#{resource}", to: "#{resource}#create") if actions.include?(:create)
      get("/#{resource}/:id", to: "#{resource}#show") if actions.include?(:show)
      get("/#{resource}/:id/edit", to: "#{resource}#edit") if actions.include?(:edit)
      put("/#{resource}/:id", to: "#{resource}#update") if actions.include?(:update)
      patch("/#{resource}/:id", to: "#{resource}#update") if actions.include?(:update)
      delete("/#{resource}/:id", to: "#{resource}#destroy") if actions.include?(:destroy)
      # rubocop:enable Metrics/LineLength
    end

    def get_required_actions(options)
      actions = [:index, :new, :create, :show, :edit, :update, :destroy]
      actions -= options[:except] if options.key?(:except)
      actions &= options[:only] if options.key?(:only)
      actions
    end

    private :get_required_actions
  end
end

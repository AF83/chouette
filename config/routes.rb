ChouetteIhm::Application.routes.draw do
  devise_for :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  
  resources :file_validations

  resources :referentials do
    resources :stop_point_areas
    match 'lines' => 'lines#destroy_all', :via => :delete
    resources :lines, :networks do
      resources :stop_areas do
        resources :stop_area_parents
        resources :stop_area_children
        resources :stop_area_routing_lines
        resources :stop_area_routing_stops
        member do
          get 'add_children'
          get 'select_parent'
          get 'add_routing_lines'
          get 'add_routing_stops'
        end
      end        
      resources :routes do
        resources :journey_patterns do
          member do
            get 'new_vehicle_journey'
          end
        end
        resources :vehicle_journeys do
          member do
            get 'select_journey_pattern'
          end
        end
        resources :stop_points do
          collection do
              post :sort
          end
        end
      end
    end

    resources :imports
    resources :exports do
      collection do
        get 'references'
      end
    end

    resources :companies
    
    resources :time_tables do
      collection do
        get :comment_filter
      end
      resources :time_table_dates
      resources :time_table_periods
    end

    resources :stop_areas do
        resources :stop_area_parents
        resources :stop_area_children
        resources :stop_area_routing_lines
        resources :stop_area_routing_stops
        member do
          get 'add_children'
          get 'select_parent'
          get 'add_routing_lines'
          get 'add_routing_stops'
        end
    end

    resources :connection_links do
      resources :connection_link_areas 
      member do
        get 'select_areas'
      end
      resources :stop_areas do
        resources :stop_area_parents
        resources :stop_area_children
        resources :stop_area_routing_lines
        resources :stop_area_routing_stops
        member do
          get 'add_children'
          get 'select_parent'
          get 'add_routing_lines'
          get 'add_routing_stops'
        end
      end        
    end

  end 

  match '/help/(*slug)' => 'help#show'

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'referentials#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

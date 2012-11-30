ChouetteIhm::Application.routes.draw do

  devise_scope :users do
    match "/users/sign_up" => "subscriptions#new"
  end
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :networks
      resources :lines do
        resources :routes
      end
    end
  end
  

  resource :subscription

  resource :organisation do
    resources :users
  end

  resources :file_validations

  resources :referentials do
    resources :stop_point_areas
    match 'lines' => 'lines#destroy_all', :via => :delete
    resources :group_of_lines do
      resources :stop_areas do
        resources :access_points
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
      resources :lines
      collection do
        get :name_filter
      end
    end

    resources :lines do
      collection do
        get :name_filter
      end
    end

    resources :lines, :networks, :group_of_lines do
      resources :stop_areas do
        resources :access_points
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
          get 'timeless', :on => :collection
          get 'select_journey_pattern', :on => :member
          resources :vehicle_translations
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

    resources :access_points do
       resources :access_links
    end

    resources :stop_areas do
      resources :access_points 
      resources :stop_area_parents
      resources :stop_area_children
      resources :stop_area_routing_lines
      resources :stop_area_routing_stops
      member do
        get 'add_children'
        get 'select_parent'
        get 'add_routing_lines'
        get 'add_routing_stops'
        get 'access_links'
      end
      collection do 
        put 'default_geometry'
      end
    end

    resources :connection_links do
      resources :connection_link_areas 
      member do
        get 'select_areas'
      end
      resources :stop_areas do
        resources :access_points
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

    resources :clean_ups
    
  end 

  match '/help/(*slug)' => 'help#show'
  match '/test_sheet/(*slug)' => 'test_sheet#show'

  root :to => 'referentials#index'
end

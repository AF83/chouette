ChouetteIhm::Application.routes.draw do
  scope ENV['RAILS_RELATIVE_URL_ROOT'] || '/' do
    devise_for :users

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

      resources :companies, :stop_areas  
      
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

    root :to => 'referentials#index'
  end
end

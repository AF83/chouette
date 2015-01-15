ChouetteIhm::Application.routes.draw do

  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :users

  devise_scope :user do
    authenticated :user do
      root :to => 'referentials#index', as: :authenticated_root
    end
    unauthenticated :user do
      root :to => 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  namespace :api do
    namespace :v1 do
      resources :time_tables, :only => [:index, :show]
      resources :connection_links, :only => [:index, :show]
      resources :companies, :only => [:index, :show]
      resources :networks, :only => [:index, :show]
      resources :stop_areas, :only => [:index, :show]
      resources :group_of_lines, :only => [:index, :show]
      resources :access_points, :only => [:index, :show]
      resources :access_links, :only => [:index, :show]
      resources :lines, :only => [:index, :show] do
        resources :journey_patterns, :only => [:index, :show]
        resources :routes, :only => [:index, :show] do
          resources :vehicle_journeys, :only => [:index, :show]
          resources :journey_patterns, :only => [:index, :show]
          resources :stop_areas, :only => [:index, :show]
        end
      end
      resources :routes, :only => :show
      resources :journey_patterns, :only => :show
      resources :vehicle_journeys, :only => :show
    end
  end


  resource :subscription

  resource :organisation do
    resources :users
  end

  resources :referentials do
    resources :api_keys
    resources :rule_parameter_sets
    resources :autocomplete_stop_areas
    resources :autocomplete_time_tables
    # TODO : TO fix
    #get 'lines' => 'lines#destroy_all'
    resources :group_of_lines do
      collection do
        get :name_filter
      end
    end
    resources :lines do
      collection do
        get :name_filter
      end
      resources :routes do
        member do
          get 'edit_boarding_alighting'
          put 'save_boarding_alighting'
        end
      end
    end

    resources :lines, :networks, :group_of_lines do
      resources :routes do
        resources :journey_patterns do
          member do
            get 'new_vehicle_journey'
          end
        end
        resources :vehicle_journeys do
          get 'select_journey_pattern', :on => :member
          resources :vehicle_translations
          resources :time_tables
        end
        resources :vehicle_journey_imports
        resources :vehicle_journey_exports
      end
    end

    resources :import_tasks do
      member do
        get 'file_to_import'
      end
    end

    resources :exports do
      collection do
        get 'references'
      end
    end
    resources :compliance_check_tasks do
      member do
        get 'export', defaults: { format: 'zip' }
      end
      member do
        get 'rule_parameter_set'
      end
      collection do
        get 'references'
      end

      resources :compliance_check_results
    end

    resources :companies

    resources :time_tables do
      collection do
        get :tags
      end
      member do
        get 'duplicate'
      end
      resources :time_table_dates
      resources :time_table_periods
      resources :time_table_combinations
    end

    resources :access_points do
       resources :access_links
    end

    resources :stop_areas do
      resources :access_points
      resources :stop_area_copies
      resources :stop_area_routing_lines
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
      resources :stop_areas
      member do
        get 'select_areas'
      end
    end
    resources :clean_ups

  end

  get '/help/(*slug)' => 'help#show'

  get '/404', :to => 'errors#not_found'
  get '/422', :to => 'errors#server_error'
  get '/500', :to => 'errors#server_error'

end

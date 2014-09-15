class NetworksController < ChouetteController
  defaults :resource_class => Chouette::Network
  respond_to :html
  respond_to :xml
  respond_to :json
  respond_to :kml, :only => :show
  respond_to :js, :only => :index

  belongs_to :referential

  def show
    @map = NetworkMap.new(resource).with_helpers(self)
    show! do
      add_breadcrumb Referential.human_attribute_name("networks"), referential_networks_path(@referential)
    end
  end

  def index    
    index! do |format|
      format.html {
        if collection.out_of_bounds?
          redirect_to params.merge(:page => 1)
        end
      }
    end       
  end

  def new
    new! do
      add_breadcrumb Referential.human_attribute_name("networks"), referential_networks_path(@referential)
    end
  end
  
  def edit
    edit! do
      add_breadcrumb Referential.human_attribute_name("networks"), referential_networks_path(@referential)
      add_breadcrumb @network.name, referential_line_path(@referential, @network)
    end
  end

  protected

  def collection    
    @q = referential.networks.search(params[:q])
    @networks ||= @q.result(:distinct => true).order(:name).paginate(:page => params[:page])
  end

  def resource_url(network = nil)
    referential_network_path(referential, network || resource)
  end

  def collection_url
    referential_networks_path(referential)
  end
end

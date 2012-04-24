class RoutesController < ChouetteController
  defaults :resource_class => Chouette::Route

  respond_to :html, :xml, :json

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line, :optional => true, :polymorphic => true
  end

  def index     
    index! do |format|
      format.html { redirect_to referential_line_path(@referential,@line) }
    end
  end

  def show
    @stop_areas = resource.stop_areas.paginate(:page => params[:page], :per_page => 10)
    show!
  end

  def destroy
    destroy! do |success, failure|
      success.html { redirect_to referential_line_path(@referential,@line) }
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to referential_line_path(@referential,@line) }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to referential_line_path(@referential,@line) }
    end
  end
  protected

  alias_method :route, :resource

  def collection
    @q = parent.routes.search(params[:q])
    @routes ||= 
      begin
        routes = @q.result(:distinct => true).order(:name)
        routes = routes.paginate(:page => params[:page], :per_page => @per_page) if @per_page.present?
        routes
      end
  end

end


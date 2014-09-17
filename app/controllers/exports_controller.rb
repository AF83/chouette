class ExportsController < ChouetteController

  respond_to :html, :xml, :json, :js
  respond_to :zip, :only => :show

  belongs_to :referential

  def new
    new! do
      add_breadcrumb Referential.human_attribute_name("exports"), referential_exports_path(@referential)
      available_exports
    end
  end

  def create
    create! do |success, failure|
      available_exports
      success.html { flash[:notice] = I18n.t('exports.new.flash')+"<br/>"+I18n.t('exports.new.flash2'); redirect_to referential_exports_path(@referential) }
    end
  end

  def show
    add_breadcrumb Referential.human_attribute_name("exports"), referential_exports_path(@referential)
    show! do |format|
      format.zip { send_file @export.file, :type => :zip }
    end
  end

  def references
    @references = referential.send(params[:type]).where("name ilike ?", "%#{params[:q]}%")
    respond_to do |format|
      format.json do
        render :json => @references.collect { |child| { :id => child.id, :name => child.name } }
      end
    end
  end

  protected

  def available_exports
    @available_exports ||= Export.types.collect do |type|
      unless @export.type == type
        @referential.exports.build :type => type
      else
        @export
      end
    end
  end

  # FIXME why #resource_id is nil ??
  def build_resource
    super.tap do |export|
      export.referential_id = @referential.id
    end
  end

  def collection
    @exports ||= end_of_association_chain.order('created_at DESC').paginate(:page => params[:page])
  end

end

class Export
  extend Enumerize
  extend ActiveModel::Naming
  include ActiveModel::Model  
  
  enumerize :export_status, in: %w{created scheduled terminated canceled aborted}, default: "created", predicates: true
  enumerize :export_format, in: %w{neptune netex gtfs hub kml}, default: "neptune", predicates: true
  
  attr_reader :datas

  def initialize(options=Hashie::Mash.new)
    @datas = options
    @export_status = @datas.status.downcase if @datas.status
    @export_format = @datas.type.downcase if @datas.type
  end

  def percentage_progress
    if %w{created}.include? export_status
      0
    elsif %w{ terminated canceled aborted }.include? export_status
      100
    else
      20
    end
  end

  def links
    @datas.links
  end

  def name
    @datas.parameters.name
  end

  def user_name
    @datas.parameters.user_name
  end

  def no_save
    @datas.parameters.no_save
  end

  def filename
    @datas.filename
  end

  def created_at
    Time.at(@datas.created.to_i / 1000)
  end

  def updated_at
    Time.at(@datas.updated.to_i / 1000)
  end

end

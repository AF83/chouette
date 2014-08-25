class StopAreaParentsController < ChouetteController

  respond_to :json, :only => :index

  def index
    respond_to do |format|  
      format.json { render :json => parents_maps }  
    end  
  end

  def parents_maps
    parents.collect do |area|
      { :id => area.id.to_s, 
        :name => area.name,
        :country_code =>  area.country_code,
        :zip_code => area.zip_code || "",
        :city_name => area.city_name || "",
        :area_type => t("area_types.label.#{area.area_type.underscore}")
      }
    end
  end

  def parents 
    referential.stop_areas.find(params[:stop_area_id]).possible_parents.select{ |p| p.name =~ /#{params[:q]}/i  }       
  end

end

class StopAreaMap < ApplicationMap

  attr_reader :stop_area

  attr_accessor :editable
  alias_method :editable?, :editable

  def initialize(stop_area)
    @stop_area = stop_area
  end

  def map
    @map ||= MapLayers::Map.new(id, :projection => projection("EPSG:900913"), :controls => controls) do |map, page|
      page << map.add_layer(MapLayers::OSM_MAPNIK)
      page << map.add_layer(google_physical) 
      page << map.add_layer(google_streets) 
      page << map.add_layer(google_hybrid) 
      page << map.add_layer(google_satellite) 

      page.assign "edit_stop_area_layer", kml_layer(stop_area, { :default => editable? }, :style_map => StyleMap::EditStopAreaStyleMap.new.style_map)
      page << map.add_layer(:edit_stop_area_layer)
      
      
      if editable?
       page.assign "referential_projection", projection_type.present? ? projection("EPSG:" + projection_type) : JsVar.new("undefined")  
        # TODO virer ce code inline       
        page << <<EOF
        edit_stop_area_layer.events.on({ 
                          'afterfeaturemodified': function(event) { 
                            geometry = event.feature.geometry.clone().transform(new OpenLayers.Projection("EPSG:900913"), new OpenLayers.Projection("EPSG:4326"));
                            $('#stop_area_longitude').val(geometry.x);
                            $('#stop_area_latitude').val(geometry.y);

                            if(referential_projection != undefined)
                            {
                              projection_geometry = event.feature.geometry.clone().transform(new OpenLayers.Projection("EPSG:900913"), referential_projection );
                              $('#stop_area_x').val(projection_geometry.x);
                              $('#stop_area_y').val(projection_geometry.y);                                                   }
                           }
                        });
EOF
        page << map.add_control(OpenLayers::Control::ModifyFeature.new(:edit_stop_area_layer, :mode => 8, :autoActivate => true))

      end

      page << map.set_center(center.to_google.to_openlayers, 16, false, true)
    end
  end
  
  def projection_type
    stop_area.referential.projection_type
  end

  def ready?
    center.present?
  end

  def center
    stop_area.geometry or stop_area.default_position
  end

end

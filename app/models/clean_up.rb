class CleanUp
  include ActiveModel::Validations  
  include ActiveModel::Conversion  
  extend ActiveModel::Naming
  
    
  attr_accessor :expected_date, :keep_lines, :keep_stops , :keep_companies
  attr_accessor :keep_networks, :keep_group_of_lines
  
  validates_presence_of :expected_date

  def initialize(attributes = {})
    attributes.each do |name, value|  
      send("#{name}=", value)  
    end  
  end  
    
  def persisted?  
    false  
  end 

  def clean
    result = CleanUpResult.new
    # find and remove time_tables 
    tms = Chouette::TimeTable.validity_out_from_on?(Date.parse(expected_date))
    result.time_table_count = tms.size
    tms.each do |tm|
      tm.destroy
    end
    # remove vehiclejourneys without timetables
    Chouette::VehicleJourney.find_each(:conditions => "id not in (select distinct vehicle_journey_id from time_tables_vehicle_journeys)") do |vj|
      if vj.time_tables.size == 0
        result.vehicle_journey_count += 1
        vj.destroy
      end
    end
    # remove journeypatterns without vehicle journeys
    Chouette::JourneyPattern.find_each(:conditions => "id not in (select distinct journey_pattern_id from vehicle_journeys)") do |jp|
      if jp.vehicle_journeys.size == 0
        result.journey_pattern_count += 1
        jp.destroy
      end
    end
    # remove routes without journeypatterns 
    Chouette::Route.find_each(:conditions => "id not in (select distinct route_id from journey_patterns)") do |r|
      if r.journey_patterns.size == 0
        result.route_count += 1
        r.destroy
      end
    end
    # if asked remove lines without routes
    if keep_lines == "0" 
      Chouette::Line.find_each(:conditions => "id not in (select distinct line_id from routes)") do |l|
        if l.routes.size == 0
          result.line_count += 1
          l.destroy
        end
      end
    end
    # if asked remove stops without children (recurse) 
    if keep_stops == "0" 
      Chouette::StopArea.find_each(:conditions => { :area_type => "BoardingPosition" }) do |bp|
        if bp.stop_points.size == 0
          result.stop_count += 1
          bp.destroy
        end
      end
      Chouette::StopArea.find_each(:conditions => { :area_type => "Quay" }) do |q|
        if q.stop_points.size == 0
          result.stop_count += 1
          q.destroy
        end
      end
      Chouette::StopArea.find_each(:conditions => { :area_type => "CommercialStopPoint" }) do |csp|
        if csp.children.size == 0
          result.stop_count += 1
          csp.destroy
        end
      end
      Chouette::StopArea.find_each(:conditions => { :area_type => "StopPlace" }) do |sp|
        if sp.children.size == 0
          result.stop_count += 1
          sp.destroy
        end
      end
      Chouette::StopArea.find_each(:conditions => { :area_type => "ITL" }) do |itl|
        if itl.routing_stops.size == 0
          result.stop_count += 1
          itl.destroy
        end
      end
    end
    # if asked remove companies without lines or vehicle journeys
    if keep_companies == "0" 
      Chouette::Company.find_each do |c|
        if c.lines.size == 0
          result.company_count += 1
          c.destroy
        end
      end
    end
    
    # if asked remove networks without lines
    if keep_networks == "0" 
      Chouette::Network.find_each do |n|
        if n.lines.size == 0
          result.network_count += 1
          n.destroy
        end
      end
    end
    
    # if asked remove group_of_lines without lines
    if keep_group_of_lines == "0" 
      Chouette::GroupOfLine.find_each do |n|
        if n.lines.size == 0
          result.group_of_line_count += 1
          n.destroy
        end
      end
    end
    result
  end
  
end

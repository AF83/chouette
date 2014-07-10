class Chouette::Hub::LineExporter
  include ERB::Util
  attr_accessor :line, :directory, :template
  
  def initialize(line, directory)
    @line = line
    @directory = directory
    @template = File.open('app/views/api/hub/lignes.hub.erb' ){ |f| f.read }
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/LIGNE.TXT"
  end
  
  def self.save( lines, directory, hub_export)
    lines.each do |line|
      self.new( line, directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|LINE_COUNT", :arguments => {"0" => lines.size})
  end
  
  def save
    File.open(directory + hub_name , "a") do |f|
      f.write("LIGNE\n") if f.size == 0
      f.write(render)
    end if line.present?
  end
end


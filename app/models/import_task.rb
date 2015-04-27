require "zip"

class ImportTask
  extend Enumerize
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion

  # TODO : Move in configuration
  @@root = "#{Rails.root}/tmp/imports"
  cattr_accessor :root

  enumerize :data_format, in: %w( neptune netex gtfs )
  attr_accessor :rule_parameter_set_id, :referential_id, :user_id, :user_name, :data_format, :resources, :name
  
  validates_presence_of :referential_id
  validates_presence_of :resources
  validates_presence_of :user_id
  validates_presence_of :user_name
  validates_presence_of :name
  
  def initialize( params = {} )
    params.each {|k,v| send("#{k}=",v)}
  end

  def referential
    Referential.find(referential_id)
  end

  def organisation
    referential.organisation
  end

  def rule_parameter_set
    organisation.rule_parameter_sets.find(rule_parameter_set_id) if rule_parameter_set_id.present?
  end

  def save
    # Save resources 
    save_resources

    # Call Iev Server
    begin 
      Ievkit.create_job(referential.name, "importer", data_format, {
                                                  :file1 => action_params_io,
                                                  :file2 => transport_data_io
                        }
                        
                       )

      # Delete resources
      delete_resources
    rescue Exception => exception
      # If iev server has an error must delete resources before
      delete_resources

      raise exception
    end
  end

  def action_params
    {
      "parameters" => {}
    }
  end

  
  def self.data_formats
    self.data_format.values
  end
    
  def action_params_io
    file = StringIO.new( action_params.to_s )
    Faraday::UploadIO.new(file, "application/json", "parameters.json")
  end

  def transport_data_io
    file = File.new(saved_resources_path, "r")
    if file_extname == ".zip"
      Faraday::UploadIO.new(file, "application/zip", original_filename )
    elsif file_extname == ".xml"
      Faraday::UploadIO.new(file, "application/xml", original_filename )
    end   
  end

  # TODO : How to find RuleParameterSet
  def rule_parameter_set_io
    UploadIO.new(rule_parameter_set.parameters, "application/octet-stream", "rule_parameter_set") if rule_parameter_set.present?
  end

  def save_resources
    FileUtils.mkdir_p root
    FileUtils.cp resources.path, saved_resources_path
  end

  def delete_resources
    FileUtils.rm saved_resources_path if File.exists? saved_resources_path
  end

  def original_filename
    resources.original_filename
  end
  
  def file_extname
    File.extname(resources.original_filename)
  end

  def saved_resources_path
    "#{root}/#{Time.now.to_i}#{file_extname}"
  end

end

class Export < ActiveRecord::Base

  belongs_to :referential
  validates_presence_of :referential_id

  validates_inclusion_of :status, :in => %w{ pending completed failed }

  has_many :log_messages, :class_name => "ExportLogMessage", :order => :position, :dependent => :delete_all

  serialize :options

  include ::TypeIdsModelable

  def self.option(name)
    name = name.to_s

    define_method(name) do
      self.options and self.options[name]
    end

    define_method("#{name}=") do |prefix|
      (self.options ||= {})[name] = prefix
    end
  end


  def exporter
    exporter ||= ::Chouette::Exporter.new(referential.slug)
  end

  @@root = "#{Rails.root}/tmp/exports"
  cattr_accessor :root

  after_destroy :destroy_file
  def destroy_file
    FileUtils.rm file if File.exists? file
  end

  def file
    "#{root}/#{id}.zip"
  end

  def name
    "#{self.class.model_name.human} #{id}"
  end

  def export_options
    { :export_id => self.id, :o => export_object_type }.tap do |options|
      options[:id] = reference_ids.join(',') if reference_ids.present?
    end
  end

  def export_object_type
#    case references_type
#    when "Chouette::Network"
#      "ptnetwork"
#    else
      references_relation ? references_relation.singularize : "line"
#    end
  end

  before_validation :define_default_attributes, :on => :create
  def define_default_attributes
    self.status ||= "pending"
    self.options ||= {}
  end

  after_create :delayed_export
  def delayed_export
    delay.export
  end

  def export
    result_severity = "ok"
    FileUtils.mkdir_p root

    begin
      # delayed job may repeat call
      ExportLogMessage.where(:export_id => self.id).delete_all
      log_messages.create :severity => "ok", :key => :started

      exporter.export file, export_options

      update_attribute :status, "completed"
    rescue => e
      Rails.logger.error "Export #{id} failed : #{e}, #{e.backtrace}"
      update_attribute :status, "failed"
      result_severity = "error"
    end

    log_messages.create :severity => result_severity, :key => status
  end

  @@references_types = [ Chouette::Line, Chouette::Network, Chouette::Company ]
  cattr_reader :references_types

  validates_inclusion_of :references_type, :in => references_types.map(&:to_s), :allow_blank => true, :allow_nil => true

  def self.format_name(format)
    name_by_format = {
      "NeptuneExport" => "Neptune",
      "CsvExport" => "CSV",
      "GtfsExport" => "GTFS",
      "NetexExport" => "NeTEx",
      "KmlExport" => "KML",
      "HubExport" => "HUB"
    }
    name_by_format[format]
  end

  def self.types
    unless Rails.env.development?
      subclasses.map(&:to_s)
    else
      # FIXME
      %w{NeptuneExport CsvExport GtfsExport NetexExport KmlExport HubExport}
    end
  end

  def self.new(attributes = {}, options = {}, &block)
    if self == Export
      Object.const_get(attributes.delete(:type) || "NeptuneExport").new(attributes, options)
    else
      super
    end
  end

end


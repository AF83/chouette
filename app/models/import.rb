require 'open-uri'

class Import
  include JobConcern
  
  def compliance_check_validation_report
    Rails.cache.fetch("#{cache_key}/validation_report", expires_in: cache_expiration) do
      report_path = links["validation_report"]
      if report_path
        response = Ievkit.get(report_path)
        ComplianceCheckResult.new(response)
      else
        raise Ievkit::IevError("Impossible to access report path link for validation of import")
      end
    end
  end
  
  def report
    Rails.cache.fetch("#{cache_key}/action_report", expires_in: cache_expiration) do
      report_path = links["action_report"]
      if report_path      
        response = Ievkit.get(report_path)
        ImportReport.new(response)
      else
        nil
      end
    end
  end 

  def rule_parameter_set
    Rails.cache.fetch("#{cache_key}/validation_params", expires_in: cache_expiration) do
      rule_parameter_set_path = links["validation_params"]
      if rule_parameter_set_path
        ::JSON.load( open(rule_parameter_set_path).read )
      else
        nil
      end
    end
  end
  
  def compliance_check
    Rails.cache.fetch("#{cache_key}/validation_report", expires_in: cache_expiration) do
      compliance_check_path = links["validation_report"]
      if compliance_check_path
        ::JSON.load( open(compliance_check_path).read )
      else
        nil
      end
    end
  end

  def destroy
    delete_path =  links["delete"]
    cancel_path = links["cancel"]
    
    if delete_path
      Ievkit.delete(delete_path)
    elsif cancel_path
      Ievkit.delete(cancel_path)
    else
      nil
    end
  end

  def file_path
    links["data"]
  end

  def filename
    File.basename(file_path) if file_path
  end

  def filename_extension
    File.extname(filename).gsub(".", "") if filename
  end

  def format
    datas.type
  end
  
  def no_save
    datas.action_parameters.no_save
  end
  
end

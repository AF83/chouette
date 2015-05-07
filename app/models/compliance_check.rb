class ComplianceCheck
  include JobConcern

  def report
    Rails.cache.fetch("#{cache_key}/action_report", expires_in: cache_expiration) do
      report_path = links["action_report"]
      if report_path      
        response = Ievkit.get(report_path)
        ComplianceCheckReport.new(response)
      else
        nil
      end
    end
  end
  
  def compliance_check_validation_report
    Rails.cache.fetch("#{cache_key}/validation_report", expires_in: cache_expiration) do
      report_path = links["validation_report"]
      if report_path      
        response = Ievkit.get(report_path)
        ComplianceCheckResult.new(response)
      else
        nil
      end
    end
  end

  def rule_parameter_set
    Rails.cache.fetch("#{cache_key}/validation_params", expires_in: cache_expiration) do
      rule_parameter_set = links["validation_params"]
      if rule_parameter_set
        response = Ievkit.get(rule_parameter_set)
        rule_parameter_set = RuleParameterSet.new.tap { |rps| rps.parameters = response.validation }
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

  def format
    datas.type
  end

end

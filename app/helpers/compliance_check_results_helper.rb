module ComplianceCheckResultsHelper
  
  def status_icon( compliance_check_result_status, compliance_check_result_severity )
    if compliance_check_result_status == "na"
      ("<i class='fa fa-ban status_" + compliance_check_result_status + "_" + compliance_check_result_severity  + "'></i>").html_safe
    elsif compliance_check_result_status == "ok"
      ("<i class='fa fa-check status_" + compliance_check_result_status + "_" + compliance_check_result_severity + "'></i>").html_safe
    else
      ("<i class='fa fa-minus-circle status_" + compliance_check_result_status + "_" + compliance_check_result_severity  + "'></i>").html_safe
    end
  end
  
end

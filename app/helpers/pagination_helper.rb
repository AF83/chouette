module PaginationHelper
  def paginated_content(models, default_partial_name = nil, options = {})
    default_options = {:delete => true, :edit => true}
    options = default_options.merge(options)
    
    return "" if models.blank?
    
    html = ""
    models.each_slice(3) do |row_models|
      html += '<div class="row">'
      row_models.each do |model|
        partial_name = default_partial_name || model.class.name.underscore.gsub("chouette/", "")
        puts "PARTIAL_NAME = #{partial_name}\nMODEL = #{model.inspect}\nOPTIONS = #{options}"
        #html += '<div  class="col-md-4">' + (render :partial => partial_name, :object => model, :locals => options).to_s + '</div>'
        #html += '<div  class="col-md-4">' + "<%= link_to referential_export_path(#{model.referential}, #{model}) %>" + '</div>'
        puts "HTML= #{html}"
      end
      html += '</div>'
    end
    html.html_safe
  end
end

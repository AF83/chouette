class SearchStopAreaInput < Formtastic::Inputs::SearchInput

  def search
    if options[:json]
      tokenLimit = options[:tokenLimit].present? ? options[:tokenLimit] : "null"
      template.content_tag( :script,
       ("$(document).ready(function() {
           var item_name = function( item){
              var result = item.name;
              console.log( item );
              console.log( item.registration_number );
              if ( item.registration_number !=null && item.registration_number.length > 0) {
                 result += '  (' + item.registration_number + ')';
              }
              return result;
           };
           var item_format = function( item ){
              var info = '';
              if ( item.zip_code != null ) {
                 info += item.zip_code + ' ';
              }
              if ( item.city_name != null ) {
                 info += item.city_name;
              }
              return '<li><div class=\"name\">' + item_name( item) + '</div><div class=\"info\">' + item.area_type + '</div><div class=\"info\">' +  info + '</div></li>'
           };
           $('##{dom_id}').tokenInput('#{options[:json]}', {
             crossDomain: false,
             tokenLimit: #{tokenLimit},
             minChars: 2,
             preventDuplicates: true,
             hintText: '#{options[:hint_text]}',
             noResultsText: '#{options[:no_result_text]}',
             searchingText: '#{options[:searching_text]}',
             resultsFormatter: item_format,
             tokenFormatter: item_format
           });
        });").html_safe)
    end
  end

  def to_html
    input_wrapping do
      label_html <<
        builder.search_field(method, input_html_options) <<
          search
    end
  end

  def input_html_options
    super.merge({
                  :required          => nil,
                  :autofocus         => nil,
                  :class             => 'token-input',
                  'data-model-name' => object.class.model_name.human
                })
  end

end

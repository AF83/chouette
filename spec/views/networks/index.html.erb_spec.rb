require 'spec_helper'

describe "/networks/index", :type => :view do

  assign_referential
  let!(:networks) { assign :networks, Array.new(2){ create(:network) }.paginate }  
  let!(:search) { assign :q, Ransack::Search.new(Chouette::Network) }

  it "should render a show link for each group" do        
    render  
    networks.each do |network|      
      expect(rendered).to have_selector(".network a[href='#{view.referential_network_path(referential, network)}']", :text => network.name)
    end
  end

  it "should render a link to create a new group" do
    render
    expect(view.content_for(:sidebar)).to have_selector(".actions a[href='#{new_referential_network_path(referential)}']")
  end

end

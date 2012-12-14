require 'spec_helper'

describe Api::V1::StopAreasController do
    let!(:stop_area) { referential.stop_areas.first || create(:stop_area) }

    it_behaves_like "api key protected controller" do
      let(:data){stop_area}
    end
  describe "GET #index, route_id, line_id" do
    let!(:line) { referential.lines.first || create(:line) }
    let!(:route) { line.routes.first || create(:route, :line => line) }
    before :each do
      config_formatted_request_with_authorization( "application/json")
      get :index, :route_id => route.objectid, :line_id => route.line.objectid
    end
    it "should assign expected stop_areas" do
      assigns[:stop_areas].map(&:id).sort.should == route.stop_areas.map(&:id).sort
    end
  end
end


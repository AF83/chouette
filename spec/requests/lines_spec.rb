require 'spec_helper'

describe "Lines" do
  let!(:referential) { Factory(:referential) }
  let!(:lines) { Array.new(2) { Factory(:line) } }

  describe "GET /lines" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit referential_lines_path(referential)
      page.should have_content(lines.first.name)
    end
  end

end

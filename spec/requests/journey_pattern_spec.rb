# -*- coding: utf-8 -*-
require 'spec_helper'

describe "JourneyPatterns" do
  login_user

  let!(:referential) { create(:referential).switch }
  let!(:line) { referential; Factory(:line) }
  let!(:route) { referential; Factory(:route, :line => line) }
  let!(:journey_pattern) { referential; Factory(:journey_pattern, :route => route) }

  describe "from routes page to a journey_pattern page" do
    it "display route's journey_patterns" do
      visit referential_line_route_path(referential,line,route)
      page.should have_content(journey_pattern.name)
    end
  end
  describe "from route's page to journey_pattern's page" do
    it "display journey_pattern properties" do
      visit referential_line_route_path(referential,line,route)
      click_link "#{journey_pattern.name}"
      page.should have_content(journey_pattern.published_name)
      page.should have_content(journey_pattern.comment)
      page.should have_content(journey_pattern.registration_number)
    end
  end
  describe "from route's page, create a new journey_pattern" do      
    it "return to route's page that display new journey_pattern" do
      visit referential_line_route_path(referential,line,route)
      click_link "Ajouter une mission"
      fill_in "Nom", :with => "A to B"
      fill_in "Comment", :with => "AB"
      click_button("Créer mission")
      page.should have_content("A to B")
    end
  end
  describe "from route's page, select a journey_pattern and edit it" do      
    it "return to route's page with changed name" do
      visit referential_line_route_path(referential,line,route)
      click_link "#{journey_pattern.name}"
      click_link "Modifier cette mission"
      fill_in "Nom", :with => "#{journey_pattern.name}-changed"
      click_button("Modifier mission")
      page.should have_content("#{journey_pattern.name}-changed")
    end
  end
  describe "from route's page, select a journey_pattern and delete it" do      
    it "return to route's page without journey_pattern name" do
      visit referential_line_route_path(referential,line,route)
      click_link "#{journey_pattern.name}"
      click_link "Supprimer cette mission"
      page.should_not have_content(journey_pattern.name)
    end
  end
end


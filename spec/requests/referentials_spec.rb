# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Referentials" do
  login_user

  describe "index" do

    it "should support no referential" do
      visit referentials_path
      page.should have_content("Espace de Données")
    end

    context "when several referentials exist" do
                                                
      let!(:referentials) {  Array.new(2) { create(:referential) } } 

      it "should show n referentials" do
        pending

        visit referentials_path
        page.should have_content(referentials.first.name)
        page.should have_content(referentials.last.name)
      end
      
    end

  end
  
  describe "create" do
    
    it "should" do
      visit new_referential_path
      fill_in "Nom", :with => "Test"
      fill_in "Code", :with => "test"
      fill_in "Point haut/droite de l'emprise par défaut", :with => "0.0, 0.0"
      fill_in "Point bas/gauche de l'emprise par défaut", :with => "1.0, 1.0"
      click_button "Créer Espace de Données"

      Referential.where(:name => "Test").should_not be_nil
      # CREATE SCHEMA
    end

  end

  describe "destroy" do
    let(:referential) {  create(:referential) } 

    it "should remove referential" do
      pending "Unauthorized DELETE (ticket #14)"
      visit referential_path(referential)
      click_link "Supprimer"
      Referential.where(:slug => referential.slug).should be_blank
    end

  end
  
end

# frozen_string_literal: true

require "application_system_test_case"

class NavigationTest < ApplicationSystemTestCase
  test "visiting the home page" do
    visit root_url
    
    assert_selector "h1", text: "GELBHART"
    assert_selector "h1 span.text-gradient-primary", text: "INNOVATIONS"
  end

  test "navigating to services page" do
    visit root_url
    click_on "Services"
    
    assert_selector "h1", text: "Services"
    assert_selector "h2", text: "Pharmaceutical Services"
    assert_selector "h2", text: "Real Estate Services"
  end

  test "navigating to pharmaceutical services" do
    visit services_url
    click_on "Pharmaceutical Services"
    
    assert_selector "h1", text: "Pharmaceutical Services"
  end

  test "navigating to real estate services" do
    visit services_url
    click_on "Real Estate Services"
    
    assert_selector "h1", text: "Real Estate Services"
  end

  test "navigating to team page" do
    visit root_url
    click_on "Team"
    
    assert_selector "h2", text: "Our leadership"
  end

  test "navigating to contact page" do
    visit root_url
    click_on "Contact Us"
    
    assert_selector "title", text: "Contact Us", visible: false
  end
end


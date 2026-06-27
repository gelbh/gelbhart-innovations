# frozen_string_literal: true

require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
    assert_select "title", "Home | Gelbhart Innovations"
  end

  test "should get services" do
    get services_url
    assert_response :success
    assert_select "h1", "Services"
  end

  test "should get pharmaceutical" do
    get pharmaceutical_url
    assert_response :success
    assert_select "h1", "Pharmaceutical Services"
    assert_select ".pharma-journey__stage", 6
    assert_select ".service-member-spotlight", 1
  end

  test "should get real_estate" do
    get real_estate_url
    assert_response :success
    assert_select "h1", "Real Estate Services"
    assert_select ".realestate-journey__stage", 5
    assert_select ".service-member-spotlight", 1
  end

  test "should get sustainability" do
    get sustainability_url
    assert_response :success
    assert_select "h1", "Sustainability Services"
    assert_select ".sustainability-journey__stage", 5
    assert_select ".service-member-spotlight", 1
  end

  test "should get full_stack" do
    get full_stack_url
    assert_response :success
    assert_select "h1.visually-hidden", "Full-stack development"
    assert_select "iframe.webdev-embed__frame[src=?]", AppConstants::PORTFOLIO_SITE_URL
  end

  test "should get team" do
    get team_url
    assert_response :success
    assert_select "h1", "Our leadership"
  end

  test "should get contact" do
    get contact_url
    assert_response :success
    assert_select "title", /Contact Us/
  end
end


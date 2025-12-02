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
    assert_select ".service-card", minimum: 1
  end

  test "should get real_estate" do
    get real_estate_url
    assert_response :success
    assert_select "h1", "Real Estate Services"
    assert_select ".service-card", minimum: 1
  end

  test "should get team" do
    get team_url
    assert_response :success
    assert_select "h2", "Our leadership"
  end

  test "should get contacts" do
    get contacts_url
    assert_response :success
    assert_select "title", /Contact Us/
  end
end


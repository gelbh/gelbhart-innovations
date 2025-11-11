# frozen_string_literal: true

require "test_helper"

class BreadcrumbHelperTest < ActionView::TestCase
  def controller
    @mock_controller ||= Struct.new(:controller_name).new("pages")
  end

  def action_name
    @mock_action ||= "index"
  end

  test "breadcrumb_trail includes home as first item" do
    @title = "Test"
    
    trail = breadcrumb_trail
    
    assert_equal "Home", trail.first[:name]
    assert_not_nil trail.first[:path]
  end

  test "breadcrumb_trail marks last item as current" do
    @title = "Test Page"
    
    trail = breadcrumb_trail
    
    assert trail.last[:current]
  end

  test "breadcrumb_trail excludes controllers in BREADCRUMB_EXCLUDED_CONTROLLERS" do
    @title = "Home"
    
    trail = breadcrumb_trail
    
    # Should not include "Pages" as middle item (pages is in excluded list)
    assert_equal 2, trail.size # Home + current page
    assert_equal "Home", trail.first[:name]
    assert trail.last[:current]
  end

  test "breadcrumb_trail includes Services for service actions" do
    @mock_action = "pharmaceutical"
    @title = "Pharmaceutical Services"
    
    trail = breadcrumb_trail
    
    # Should include Home, Services, and Pharmaceutical
    assert_equal 3, trail.size
    assert_equal "Home", trail[0][:name]
    assert_equal "Services", trail[1][:name]
    assert_not_nil trail[1][:path]
    assert_equal "Pharmaceutical", trail[2][:name]
    assert trail[2][:current]
  end
end


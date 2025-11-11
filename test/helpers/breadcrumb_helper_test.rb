# frozen_string_literal: true

require "test_helper"

class BreadcrumbHelperTest < ActionView::TestCase
  def setup
    @controller = PagesController.new
  end

  test "breadcrumb_trail includes home as first item" do
    trail = breadcrumb_trail
    
    assert_equal "Home", trail.first[:name]
    assert_equal root_path, trail.first[:path]
  end

  test "breadcrumb_trail marks last item as current" do
    @title = "Test Page"
    trail = breadcrumb_trail
    
    assert trail.last[:current]
  end

  test "breadcrumb_trail excludes controllers in BREADCRUMB_EXCLUDED_CONTROLLERS" do
    def controller
      controller = OpenStruct.new
      controller.controller_name = "pages"
      controller
    end
    
    def action_name
      "index"
    end
    
    trail = breadcrumb_trail
    
    # Should not include "Pages" as middle item
    assert_equal 2, trail.size # Home + current page
  end

  test "breadcrumb_trail includes Services for service actions" do
    def controller
      controller = OpenStruct.new
      controller.controller_name = "pages"
      controller
    end
    
    def action_name
      "pharmaceutical"
    end
    
    @title = "Pharmaceutical Services"
    trail = breadcrumb_trail
    
    # Should include Home, Services, and Pharmaceutical
    assert_equal 3, trail.size
    assert_equal "Services", trail[1][:name]
    assert_equal services_path, trail[1][:path]
  end
end


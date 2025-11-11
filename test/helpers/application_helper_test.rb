# frozen_string_literal: true

require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "nav_active_class returns active when on current page" do
    def current_page?(path)
      path == "/test"
    end
    
    assert_equal "active", nav_active_class("/test")
  end

  test "nav_active_class returns empty string when not on current page" do
    def current_page?(path)
      false
    end
    
    assert_equal "", nav_active_class("/test")
  end

  test "nav_active_class checks multiple paths" do
    def current_page?(path)
      path == "/services"
    end
    
    assert_equal "active", nav_active_class("/home", "/services", "/about")
  end

  test "full_page_title returns title with suffix when title provided" do
    assert_equal "Home / Gelbhart Inn.", full_page_title("Home")
  end

  test "full_page_title returns default when no title provided" do
    assert_equal "Gelbhart Inn.", full_page_title(nil)
  end

  test "page_description returns provided description" do
    assert_equal "Test description", page_description("Test description")
  end

  test "page_description returns empty string when nil" do
    assert_equal "", page_description(nil)
  end
end


require "test_helper"

class SharedControllerTest < ActionDispatch::IntegrationTest
  test "should get _header" do
    get shared__header_url
    assert_response :success
  end

  test "should get _footer" do
    get shared__footer_url
    assert_response :success
  end
end

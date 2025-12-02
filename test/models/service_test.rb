# frozen_string_literal: true

require "test_helper"

class ServiceTest < ActiveSupport::TestCase
  test "pharmaceutical services returns array of services" do
    services = Service.pharmaceutical

    assert_instance_of Array, services
    assert_operator services.size, :>, 0
    assert_instance_of Service, services.first
  end

  test "pharmaceutical services have required attributes" do
    service = Service.pharmaceutical.first

    assert_not_nil service.title
    assert_not_nil service.icon
    assert_not_nil service.description
    assert_respond_to service, :subtitle
  end

  test "real estate services returns array of services" do
    services = Service.real_estate

    assert_instance_of Array, services
    assert_operator services.size, :>, 0
    assert_instance_of Service, services.first
  end

  test "real estate services have required attributes" do
    service = Service.real_estate.first

    assert_not_nil service.title
    assert_not_nil service.icon
    assert_not_nil service.description
  end

  test "real estate services descriptions are arrays" do
    services = Service.real_estate

    services.each do |service|
      assert_instance_of Array, service.description
    end
  end

  test "service initializes with all attributes" do
    service = Service.new(
      title: "Test Service",
      icon: "bx bx-test",
      subtitle: "Test Subtitle",
      description: "Test Description"
    )

    assert_equal "Test Service", service.title
    assert_equal "bx bx-test", service.icon
    assert_equal "Test Subtitle", service.subtitle
    assert_equal "Test Description", service.description
  end
end


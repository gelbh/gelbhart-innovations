# frozen_string_literal: true

require "test_helper"

class ServicesHelperTest < ActionView::TestCase
  include ServicesHelper

  test "real_estate_services_by_phase groups services in pipeline order" do
    services = Service.real_estate
    grouped = real_estate_services_by_phase(services)

    assert_equal 3, grouped.size
    assert_equal %i[pre_development construction post_development], grouped.map { |g| g[:phase] }
    assert_equal %w[land_identification acquisition], grouped[0][:services].map(&:key)
    assert_equal %w[development], grouped[1][:services].map(&:key)
    assert_equal %w[marketing financial], grouped[2][:services].map(&:key)
  end

  test "service_description_items normalizes string and array descriptions" do
    pharma = Service.pharmaceutical.first
    assert_equal [pharma.description], service_description_items(pharma)

    re = Service.real_estate.first
    assert_kind_of Array, service_description_items(re)
    assert service_description_items(re).many?
  end
end

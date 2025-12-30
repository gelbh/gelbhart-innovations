# frozen_string_literal: true

class Service
  attr_reader :key, :icon, :category

  PHARMACEUTICAL_SERVICES = [
    { key: "due_diligence", icon: "bx bxs-analyse" },
    { key: "business_development", icon: "bx bxs-network-chart" },
    { key: "portfolio", icon: "bx bxs-briefcase" },
    { key: "strategy", icon: "bx bxs-chess" },
    { key: "orphan_drugs", icon: "bx bxs-capsule" },
    { key: "product_launch", icon: "bx bxs-rocket" }
  ].freeze

  REAL_ESTATE_SERVICES = [
    { key: "land_identification", icon: "bx bxs-map" },
    { key: "acquisition", icon: "bx bxs-bank" },
    { key: "development", icon: "bx bxs-cog" },
    { key: "marketing", icon: "bx bxs-megaphone" },
    { key: "financial", icon: "bx bxs-calculator" }
  ].freeze

  def initialize(key:, icon:, category:)
    @key = key
    @icon = icon
    @category = category
  end

  def title = I18n.t("services_data.#{category}.#{key}.title")
  def subtitle = I18n.t("services_data.#{category}.#{key}.subtitle", default: nil)
  def description = I18n.t("services_data.#{category}.#{key}.description")

  class << self
    def pharmaceutical
      build_services(PHARMACEUTICAL_SERVICES, :pharmaceutical)
    end

    def real_estate
      build_services(REAL_ESTATE_SERVICES, :real_estate)
    end

    private

    def build_services(definitions, category)
      definitions.map { |attrs| new(**attrs, category: category) }
    end
  end
end

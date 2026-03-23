# frozen_string_literal: true

class Service
  attr_reader :key, :icon, :category, :member_key

  PHARMACEUTICAL_SERVICES = [
    { key: "due_diligence", icon: "bx bxs-analyse", member_key: :bareket },
    { key: "business_development", icon: "bx bxs-network-chart", member_key: :bareket },
    { key: "portfolio", icon: "bx bxs-briefcase", member_key: :bareket },
    { key: "strategy", icon: "bx bxs-chess", member_key: :bareket },
    { key: "orphan_drugs", icon: "bx bxs-capsule", member_key: :bareket },
    { key: "product_launch", icon: "bx bxs-rocket", member_key: :bareket }
  ].freeze

  REAL_ESTATE_SERVICES = [
    { key: "land_identification", icon: "bx bxs-map", member_key: :yaron },
    { key: "acquisition", icon: "bx bxs-bank", member_key: :yaron },
    { key: "development", icon: "bx bxs-cog", member_key: :yaron },
    { key: "marketing", icon: "bx bxs-megaphone", member_key: :yaron },
    { key: "financial", icon: "bx bxs-calculator", member_key: :yaron }
  ].freeze

  def initialize(key:, icon:, category:, member_key:)
    @key = key
    @icon = icon
    @category = category
    @member_key = member_key
  end

  def title = I18n.t("services_data.#{category}.#{key}.title")
  def subtitle = I18n.t("services_data.#{category}.#{key}.subtitle", default: nil)
  def description = I18n.t("services_data.#{category}.#{key}.description")

  def member
    TeamMember.find_by_key(member_key) || raise(KeyError, "Unknown member_key #{member_key.inspect} for service #{category}/#{key}")
  end

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

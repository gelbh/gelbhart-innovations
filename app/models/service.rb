# frozen_string_literal: true

# Plain Old Ruby Object for services
# Not backed by database - used for static service data
class Service
  attr_reader :title, :icon, :subtitle, :description

  def initialize(title:, icon:, subtitle:, description:)
    @title = title
    @icon = icon
    @subtitle = subtitle
    @description = description
  end

  # Pharmaceutical services
  def self.pharmaceutical
    [
      new(
        title: "Due Diligence",
        icon: "bx bxs-analyse",
        subtitle: "Are you considering to purchase a new pharmaceutical asset, be it a product or a company?",
        description: "With more than 27 years of experience in the pharmaceutical industry, we provide assistance and advice in relation to any due diligence of a pharmaceutical product and a pharmaceutical company, including assessment, evaluation, structuring, negotiation and completion of a potential investment."
      ),
      new(
        title: "Business Development (Partnerships)",
        icon: "bx bxs-network-chart",
        subtitle: "Are you developing a new product and looking for the best partner or looking to license out your product?",
        description: "With our industry experience and knowledge, we can find the right partner to your API, FDF and/or Orphan Generic Drug worldwide."
      ),
      new(
        title: "Portfolio",
        icon: "bx bxs-briefcase",
        subtitle: "Looking for a new molecule but don't know where to start?",
        description: "With our chemistry background and industry knowledge, we can help you find the right molecules to develop, whether they are small niche molecules or future blockbusters, bread & butter or pearls. We will define the strategy for development after considering intellectual property, pricing and competition."
      ),
      new(
        title: "Strategy",
        icon: "bx bxs-chess",
        subtitle: "Not sure which road your company should follow?",
        description: "We will research and identify the market needs and market potential to develop business opportunities for the company's portfolio. We will then locate new customers and new markets in which the company's potential is not yet fully realized. We will evaluate the current sales team and recommend the right structure, identify sales personnel and train them. After reviewing agencies network we will recommend, where and if to work through agents or directly. We will define ideal pipeline process, KPIs and organization, and evaluate competitors' status."
      ),
      new(
        title: "Generic Orphan Drugs",
        icon: "bx bxs-capsule",
        subtitle: "Are you developing a Generic Orphan Drug?",
        description: "In many cases, it means investing in the development of a small niche product, but that doesn't mean the market potential is also small. Every market has its own rules for Orphan Drugs and in many cases the brand product is not approved or not marketed in a specific location. We will Identify the relevant markets & find the right local partners, doctors (KOLs), patients and patient associations to allow you to offer your product in a fast and effective way, realizing profits in early stages of the development."
      ),
      new(
        title: "Launch of New Products",
        icon: "bx bxs-rocket",
        subtitle: "Marketing authorization is just around the corner but the product is not yet ready for launch?",
        description: "We will evaluate the situation and direct your suppliers (API and/or FDF) on how to develop their capacity, open bottlenecks, solve quality problems in the manufacturing procedures quickly and effectively to enable a smooth and timely launch."
      )
    ]
  end

  # Real estate services
  def self.real_estate
    [
      new(
        title: "Land & Opportunity Identification",
        icon: "bx bxs-map",
        subtitle: nil,
        description: [
          "Sourcing high-potential land parcels for housing, hospitality, leisure, and commercial projects.",
          "Conducting in-depth market research and feasibility studies.",
          "Evaluating zoning, infrastructure, and long-term value."
        ]
      ),
      new(
        title: "Acquisition & Structuring",
        icon: "bx bxs-bank",
        subtitle: nil,
        description: [
          "Managing land purchase negotiations and due diligence.",
          "Coordinating with legal advisors, banks, and financial institutions.",
          "Structuring investments and ownership models aligned with client and investor goals."
        ]
      ),
      new(
        title: "Design & Development Management",
        icon: "bx bxs-cog",
        subtitle: nil,
        description: [
          "Leading master planning, architecture, and design processes.",
          "Overseeing consultants, contractors, and project teams.",
          "Ensuring quality, sustainability, and on-time delivery."
        ]
      ),
      new(
        title: "Marketing & Sales Execution",
        icon: "bx bxs-megaphone",
        subtitle: nil,
        description: [
          "Building brand identity and go-to-market strategy.",
          "Designing marketing campaigns to target investors and end-users.",
          "Managing sales networks and client relationships for maximum absorption."
        ]
      ),
      new(
        title: "Financial & Regulatory Coordination",
        icon: "bx bxs-calculator",
        subtitle: nil,
        description: [
          "Working closely with banks, accountants, and auditors to secure financing and maintain compliance.",
          "Managing financial reporting, investor relations, and regulatory approvals.",
          "Providing transparent oversight from concept to project handover."
        ]
      )
    ]
  end
end


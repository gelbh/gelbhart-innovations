class PagesController < ApplicationController
  include JarallaxConfiguration

  def index
    assign_page_metadata(
      title: "Home",
      description: "Gelbhart Innovations: consulting and delivery in pharmaceutical services, real estate, and full-stack software."
    )
  end

  def services
    assign_page_metadata(
      title: "Services",
      description: "Consulting and delivery in pharmaceutical services, real estate, and full-stack software, from first plan through launch and later support."
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:services])
  end

  def pharmaceutical
    assign_page_metadata(
      title: "Pharmaceutical Services",
      description: "Pharmaceutical consulting: due diligence, partnerships, portfolio choices, and product-level advice."
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:services])
    @services = Service.pharmaceutical
  end

  def real_estate
    assign_page_metadata(
      title: "Real Estate Services",
      description: "Real estate consulting: land and projects, investment analysis, market research, and portfolio structure."
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:services])
    @real_estate_services = Service.real_estate
  end

  def web_development
    assign_page_metadata(
      title: "Full-stack development",
      description: "Full-stack developer portfolio at gelbhart.dev: Rails, web stacks, projects, and tech notes."
    )
  end

  def team
    assign_page_metadata(
      title: "Team",
      description: "Leadership across pharmaceutical consulting, real estate, and full-stack software."
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:team])
    @members = TeamMember.all
  end

  def contact
    assign_page_metadata(
      title: "Contact Us",
      description: "Phone, email, and address for Gelbhart Innovations. Inquiries welcome on pharmaceutical, real estate, and software work."
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:contact], height: 300, speed: 0.1)

    # Generate LocalBusiness structured data
    contact = AppConstants::CONTACT_INFO
    address_schema = {
      "@type" => "PostalAddress",
      "streetAddress" => contact[:address][:street],
      "addressLocality" => contact[:address][:city],
      "postalCode" => contact[:address][:postal_code],
      "addressCountry" => contact[:address][:country]
    }

    @structured_data = {
      "@context" => "https://schema.org",
      "@type" => "LocalBusiness",
      "name" => "Gelbhart Innovations",
      "address" => address_schema,
      "telephone" => contact[:phone][:display],
      "email" => contact[:email],
      "url" => root_url
    }
  end
end

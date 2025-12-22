class PagesController < ApplicationController
  include JarallaxConfiguration

  def index
    assign_page_metadata(
      title: "Home",
      description: "Gelbhart Innovations delivers innovative solutions creating value through comprehensive consulting services in pharmaceutical and real estate industries."
    )
  end

  def services
    assign_page_metadata(
      title: "Services",
      description: "Explore our comprehensive consulting services including pharmaceutical industry consulting, real estate services, and specialized business development solutions."
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:services])
  end

  def pharmaceutical
    assign_page_metadata(
      title: "Pharmaceutical Services",
      description: "Comprehensive pharmaceutical industry consulting including due diligence, business development, portfolio strategy, and specialized product consulting services."
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:services])
    @services = Service.pharmaceutical
  end

  def real_estate
    assign_page_metadata(
      title: "Real Estate Services",
      description: "Expert real estate consulting services including property development, investment analysis, market research, and strategic real estate portfolio management."
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:services])
    @real_estate_services = Service.real_estate
  end

  def team
    assign_page_metadata(
      title: "Team",
      description: "Meet our experienced team of industry experts specializing in pharmaceutical consulting, real estate services, and innovative business solutions."
    )
    assign_jarallax(image: AppConstants::JARALLAX_IMAGES[:team])
    @members = TeamMember.all
  end

  def contact
    assign_page_metadata(
      title: "Contact Us",
      description: "Get in touch with Gelbhart Innovations. Contact us for inquiries about our pharmaceutical and real estate consulting services."
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
